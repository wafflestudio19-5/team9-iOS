//
//  NotificationTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class NotificationTabViewController: BaseTabViewController<NotificationTabView>, UIScrollViewDelegate {

    var tableView: UITableView {
        tabView.notificationTableView
    }
    
    let viewModel = PaginationViewModel<Notification>(endpoint: .notification())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tabView.largeTitleLabel)

        bind()
    }
    
    func bind() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.dataList
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: NotificationTableViewCell.reuseIdentifier, cellType: NotificationTableViewCell.self)) { index, notification, cell in
                print(notification)
                cell.configure(with: notification)
            }.disposed(by: disposeBag)

        StateManager.of.notification.bind(with: viewModel.dataList).disposed(by: disposeBag)

        // cell을 탭할 경우 상세 페이지로 이동
//        tableView.rx.modelSelected(Notification.self)
//            .bind { [weak self] notification in
//
//            }.disposed(by: disposeBag)
    }
}
