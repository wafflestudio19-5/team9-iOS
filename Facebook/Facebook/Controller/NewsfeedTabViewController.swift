//
//  NewsfeedTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import Alamofire
import RxSwift
import RxAlamofire

class NewsfeedTabViewController: BaseTabViewController<NewsfeedTabView> {
    
    var tableView: UITableView {
        tabView.newsfeedTableView
    }
    
    let viewModel = PaginationViewModel<Post>(endpoint: .newsfeed(page: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        viewModel.dataList
            .bind(to: tableView.rx.items(cellIdentifier: "PostCell", cellType: PostTableViewCell.self)) { row, post, cell in
                cell.configureLabels(with: post)
            }
            .disposed(by: disposeBag)
        
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
        
        tabView.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.refresh()
            })
            .disposed(by: disposeBag)
        
        viewModel.refreshComplete
            .asDriver()
            .drive(onNext : { [weak self] refreshComplete in
                if refreshComplete {
                    self?.tabView.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
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

