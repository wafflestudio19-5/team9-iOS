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
    
    /// `tableHeaderView`의 높이를 다이나믹하게 조절한다.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            // Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }
    
    func bind() {
        
        /// `무슨 생각을 하고 계신가요?` 버튼을 클릭하면 포스트 작성 화면으로 넘어가도록 바인딩
        tabView.mainTableHeaderView.createPostButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            let createPostViewController = CreatePostViewController()
            let navigationController = UINavigationController(rootViewController: createPostViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        .disposed(by: disposeBag)
        
        /// `viewModel.dataList`와 `tableView`의 dataSource를 바인딩합니다.
        viewModel.dataList
            .bind(to: tableView.rx.items(cellIdentifier: "PostCell", cellType: PostCell.self)) { row, post, cell in
                cell.configureCell(with: post)
                
                // buttons
                cell.buttonHorizontalStackView.likeButton.rx.tap.bind { [weak self] _ in
                    cell.like(post: post)
                    NetworkService.put(endpoint: .newsfeedLike(postId: post.id))
                        .bind { response in
                            print(response)
//                            cell.setLikes(count: response.1.likes)
                        }.disposed(by: cell.disposeBag)
                }.disposed(by: cell.disposeBag)
                
                cell.buttonHorizontalStackView.commentButton.rx.tap.bind { [weak self] _ in
                    self?.push(viewController: PostDetailViewController(post: post))
                }.disposed(by: cell.disposeBag)  // cell이 reuse될 때 disposeBag은 새로운 것으로 갈아끼워진다(prepareForReuse에 의해). 따라서 기존 cell의 구독이 취소된다.
            }
            .disposed(by: disposeBag)
        
        /// `isLoading` 값이 바뀔 때마다 하단 스피너를 토글합니다.
        viewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.tabView.showBottomSpinner()
                } else {
                    self?.tabView.hideBottomSpinner()
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
        tableView.rx.didScroll.subscribe { [weak self] _ in
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
