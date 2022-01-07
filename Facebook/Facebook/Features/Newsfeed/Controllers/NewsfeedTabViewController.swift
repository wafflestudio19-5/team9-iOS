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
        bindNavigationBar()
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
    
    private func bindNavigationBar() {
        tableView.rx.panGesture()
            .when(.recognized)
            .bind { [weak self] recognizer in
                guard let self = self else { return }
                let transition = recognizer.translation(in: self.tableView).y
                if transition < -100 {
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                } else if transition > 100 {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bind() {
        
        /// `무슨 생각을 하고 계신가요?` 버튼을 클릭하면 포스트 작성 화면으로 넘어가도록 바인딩
        tabView.mainTableHeaderView.createPostButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let self = self else { return }
                let createPostViewController = CreatePostViewController()
                let navigationController = UINavigationController(rootViewController: createPostViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
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
    func pushToDetailVC(cell: PostCell, asFirstResponder: Bool) {
        let detailVC = PostDetailViewController(post: cell.post, asFirstResponder: asFirstResponder)
        
        // subscribe to changes is DetailView
        detailVC.postView.postContentHeaderView.postUpdated
            .bind { updatedPost in
                cell.post = updatedPost  // cell will be updated accordingly
            }
            .disposed(by: detailVC.disposeBag)
        
        self.push(viewController: detailVC)
    }
    
    /// PostCell Configuration Logic
    func configure(cell: PostCell, with post: Post) {
        cell.configureCell(with: post)
        
        // 좋아요 버튼 바인딩
        cell.buttonHorizontalStackView.likeButton.rx.tap.bind { _ in
            cell.like()
            NetworkService.put(endpoint: .newsfeedLike(postId: post.id), as: LikeResponse.self)
                .bind { response in
                    cell.like(syncWith: response.1)
                }
                .disposed(by: cell.disposeBag)
        }.disposed(by: cell.disposeBag)
        
        // 댓글 버튼 터치 시 디테일 화면으로 이동
        cell.buttonHorizontalStackView.commentButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.pushToDetailVC(cell: cell, asFirstResponder: true)
            }.disposed(by: cell.disposeBag)
        
        let authorNameTapped = cell.postHeader.authorNameLabel.rx.tapGesture().when(.recognized)  // not working...
        let profileImageTapped = cell.postHeader.profileImageView.rx.tapGesture().when(.recognized)
        Observable.of(profileImageTapped, authorNameTapped)
            .merge()
            .bind { [weak self] _ in
                let profileVC = ProfileTabViewController(userId: post.author?.id)
                self?.push(viewController: profileVC)
            }
            .disposed(by: cell.disposeBag)
        
        // 댓글 수 클릭시 디테일 화면으로 이동
        cell.commentCountButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.pushToDetailVC(cell: cell, asFirstResponder: false)
            }.disposed(by: cell.disposeBag)
    }
}
