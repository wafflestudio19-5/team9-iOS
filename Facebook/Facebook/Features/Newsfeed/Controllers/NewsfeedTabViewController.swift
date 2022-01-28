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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tabView.logoView)
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
