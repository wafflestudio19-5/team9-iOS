//
//  NewsfeedTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import Alamofire
import RxSwift
import RxAlamofire
import UIKit
import RxCocoa
import RxGesture

class NewsfeedTabViewController: BaseTabViewController<NewsfeedTabView> {
    
    var tableView: UITableView {
        tabView.newsfeedTableView
    }
    
    var headerViews: MainHeaderView {
        tabView.mainTableHeaderView
    }
    
    let viewModel = PaginationViewModel<Post>(endpoint: .newsfeed())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.adjustHeaderHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func bind() {
        
        /// `무슨 생각을 하고 계신가요?` 버튼을 클릭하면 포스트 작성 화면으로 넘어가도록 바인딩
        tabView.mainTableHeaderView.createPostButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.presentCreatePostVC()
            }
            .disposed(by: disposeBag)
        
        /// `viewModel.dataList`와 `tableView`의 dataSource를 바인딩합니다.
        viewModel.dataList
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: PostCell.reuseIdentifier, cellType: PostCell.self)) { [weak self] row, post, cell in
                guard let self = self else { return }
                self.configure(cell: cell, with: post)
            }
            .disposed(by: disposeBag)
        
        /// `StateManager`와 `dataList`를 바인딩합니다.
        StateManager.of.post.bind(with: viewModel.dataList).disposed(by: disposeBag)
        
        /// `isLoading` 값이 바뀔 때마다 하단 스피너를 토글합니다.
        viewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.tableView.showBottomSpinner()
                } else {
                    self?.tableView.hideBottomSpinner()
                }
            })
            .disposed(by: disposeBag)
        
        /// 새로고침 제스쳐가 인식될 때마다 `refresh` 함수를 실행합니다.
        tabView.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.refresh()
            })
            .disposed(by: disposeBag)
        
        /// 새로고침이 완료될 때마다 `refreshControl`의 애니메이션을 중단시킵니다.
        viewModel.refreshComplete
            .asDriver(onErrorJustReturn: false)
            .drive(onNext : { [weak self] refreshComplete in
                if refreshComplete {
                    self?.tabView.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        /// 테이블 맨 아래까지 스크롤할 때마다 `loadMore` 함수를 실행합니다.
        tableView.rx.didScroll
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                let offSetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                    self.viewModel.loadMore()
                }
            }
            .disposed(by: disposeBag)
        
    }
}

extension UIViewController {
    
    enum PostMenu: CaseIterable {
        case edit
        case delete
        
        var text: String {
            switch self {
            case .edit:
                return "게시물 수정"
            case .delete:
                return "게시물 삭제"
            }
        }
        
        var symbolName: String {
            switch self {
            case .edit:
                return "square.and.pencil"
            case .delete:
                return "trash"
            }
        }
        
        var symbol: UIImage {
            return UIImage(systemName: symbolName)!
        }
    }
    
    private func getPostMenus(of post: Post) -> UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [
            // EDIT
            UIAction(title: PostMenu.edit.text, image: PostMenu.edit.symbol, handler: { _ in
                print(post.id)
            }),
            // DELETE
            UIAction(title: PostMenu.delete.text, image: PostMenu.delete.symbol, attributes: .destructive, handler: { _ in
                let alert = UIAlertController(title: "게시물을 삭제하시겠습니까?", message: "이 작업은 되돌릴 수 없습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                    let _ = NetworkService.delete(endpoint: .newsfeed(postId: post.id))  // single observable: no need to dispose
                    StateManager.of.post.dispatch(.init(data: post, operation: .delete(index: nil)))
                }))
                self.present(alert, animated: true, completion: nil)
            })
        ])
    }
    
    func pushToDetailVC(cell: PostCell<PostContentView>, asFirstResponder: Bool) {
        let detailVC = PostDetailViewController(post: cell.postContentView.post, asFirstResponder: asFirstResponder)
        self.push(viewController: detailVC)
    }
    
    func presentCommentModalVC(to post: Post) {
        let vc = CommentModalViewConroller(post: post, asFirstResponder: true)
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isModalInPresentation = true
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func presentCreatePostVC(sharing post: Post? = nil, update: Bool = true) {
        let createPostViewController = CreatePostViewController(sharing: post, update: update)
        let navigationController = UINavigationController(rootViewController: createPostViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    /// PostCell Configuration Logic
    func configure(cell: PostCell<PostContentView>, with post: Post) {
        cell.configure(with: post)
        
        let ellipsis = cell.postContentView.postHeader.ellipsisButton
        if post.author?.id != StateManager.of.user.profile.id {
            ellipsis.isHidden = true
        } else {
            ellipsis.isHidden = false
            ellipsis.showsMenuAsPrimaryAction = true
            ellipsis.menu = getPostMenus(of: post)
        }
        
        // 좋아요 버튼 바인딩
        cell.postContentView.buttonHorizontalStackView.likeButton.rx.tap.bind { _ in
            cell.postContentView.like()
            NetworkService.put(endpoint: .newsfeedLike(postId: post.id), as: LikeResponse.self)
                .bind { response in
                    cell.postContentView.like(syncWith: response.1)
                }
                .disposed(by: cell.refreshingBag)
        }.disposed(by: cell.refreshingBag)
        
        // 이미지 그리드 터치 제스쳐 등록
        cell.postContentView.imageGridCollectionView.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                let subpostVC = SubPostsViewController(post: cell.postContentView.post)
                self.push(viewController: subpostVC)
            }
            .disposed(by: cell.refreshingBag)
        
        // 공유된 이미지 터치 제스쳐 등록
        cell.postContentView.sharedPostView.imageGridCollectionView.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                if cell.postContentView.sharedPostView.imageGridCollectionView.numberOfImages == 1 {
                    return  // 한 장짜리 이미지는 원래 전체화면 프리뷰로 전환되어야 한다.
                }
                let subpostVC = SubPostsViewController(post: cell.postContentView.sharedPostView.post)
                self.push(viewController: subpostVC)
            }
            .disposed(by: cell.refreshingBag)
        
        // 댓글 버튼 터치 시 디테일 화면으로 이동
        cell.postContentView.buttonHorizontalStackView.commentButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.pushToDetailVC(cell: cell, asFirstResponder: true)
            }.disposed(by: cell.refreshingBag)
        
        cell.postContentView.buttonHorizontalStackView.shareButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.presentCreatePostVC(sharing: cell.postContentView.post)
            }.disposed(by: cell.refreshingBag)
        
        let authorNameTapped = cell.postContentView.postHeader.authorNameLabel.rx.tapGesture().when(.recognized)  // not working...
        let profileImageTapped = cell.postContentView.postHeader.profileImageView.rx.tapGesture().when(.recognized)
        Observable.of(profileImageTapped, authorNameTapped)
            .merge()
            .bind { [weak self] _ in
                let profileVC = ProfileTabViewController(userId: post.author?.id)
                self?.push(viewController: profileVC)
            }
            .disposed(by: cell.refreshingBag)
        
        // 댓글 수 클릭시 디테일 화면으로 이동
        cell.postContentView.commentCountButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.pushToDetailVC(cell: cell, asFirstResponder: false)
            }.disposed(by: cell.refreshingBag)
    }
}
