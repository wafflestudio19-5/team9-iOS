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
    
    private let isShowingBottomSheet: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
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
            .bind(to: tableView.rx.items(cellIdentifier: NotificationCell.reuseIdentifier, cellType: NotificationCell.self)) { [weak self] index, notification, cell in
                self?.configure(cell: cell, with: notification)
            }.disposed(by: disposeBag)

        StateManager.of.notification.bind(with: viewModel.dataList).disposed(by: disposeBag)
        
        tabView.bottomSheetView.rx.tapGesture().bind { [weak self] _ in
            self?.isShowingBottomSheet.accept(false)
        }.disposed(by: disposeBag)
        
        isShowingBottomSheet
            .observe(on: MainScheduler.instance)
            .bind { [weak self] isShowing in
            isShowing ? self?.tabView.showBottomSheetView() : self?.tabView.dismissBottomSheetView()
        }.disposed(by: disposeBag)

        // cell을 탭할 경우 상세 페이지로 이동
//        tableView.rx.modelSelected(Notification.self)
//            .bind { [weak self] notification in
//
//            }.disposed(by: disposeBag)
    }
}

extension NotificationTabViewController {
    private func configure(cell: NotificationCell, with notification: Notification) {
        cell.configure(with: notification)
        
        cell.detailButton.rx.tap.bind { [weak self] in
            self?.isShowingBottomSheet.accept(true)
        }.disposed(by: disposeBag)
    }
}
