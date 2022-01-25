//
//  NotificationTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture
import SnapKit

class NotificationTabViewController: BaseTabViewController<NotificationTabView>, UITableViewDelegate, UIScrollViewDelegate {

    var tableView: UITableView {
        tabView.notificationTableView
    }
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Notification>>(configureCell: configureCell)

    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionModel<String, Notification>>.ConfigureCell = { [weak self] dataSource, tableView, indexPath, notification in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier, for: indexPath) as? NotificationCell else { return UITableViewCell() }
        cell.configure(with: notification)
        return cell
    }
    
    private let isShowingBottomSheet: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let viewModel = PaginationViewModel<Notification>(endpoint: .notification())
    
    /// 새로운 알림, 이전 알림
    private let oldNotifications = BehaviorRelay<[Notification]>(value: [])
    private let newNotifications = BehaviorRelay<[Notification]>(value: [])
    
    private let sectionList = BehaviorRelay<[SectionModel<String, Notification>]>(value: [])
    private var sections: [SectionModel<String, Notification>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tabView.largeTitleLabel)
        
        tableView.sectionHeaderTopPadding = 0.0
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sectionList.accept([])
        sections.removeAll()
        
        if !newNotifications.value.isEmpty { sections.append(SectionModel(model: "새로운 알림", items: newNotifications.value)) }
        if !oldNotifications.value.isEmpty { sections.append(SectionModel(model: "이전 알림", items: oldNotifications.value)) }

        sectionList.accept(sections)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let oldData = self.oldNotifications.value
        self.oldNotifications.accept(oldData + newNotifications.value)
        self.newNotifications.accept([])
    }
    
    private func bind() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

//        viewModel.dataList
//            .observe(on: MainScheduler.instance)
//            .bind(to: tableView.rx.items(cellIdentifier: NotificationCell.reuseIdentifier, cellType: NotificationCell.self)) { [weak self] _, notification, cell in
//                self?.configure(cell: cell, with: notification)
//            }.disposed(by: disposeBag)
        
        viewModel.dataList
            .bind { [weak self] notification in
                self?.newNotifications.accept(notification)
            }.disposed(by: disposeBag)
        
        sectionList
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        StateManager.of.notification.bind(with: viewModel.dataList).disposed(by: disposeBag)
        
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
        
//        tabView.bottomSheetView.rx.tapGesture().bind { [weak self] _ in
//            self?.isShowingBottomSheet.accept(false)
//        }.disposed(by: disposeBag)
//
//        isShowingBottomSheet
//            .observe(on: MainScheduler.instance)
//            .bind { [weak self] isShowing in
//            isShowing ? self?.tabView.showBottomSheetView() : self?.tabView.dismissBottomSheetView()
//        }.disposed(by: disposeBag)

        /// cell을 탭하면 알림을 확인한 것으로 간주함
        Observable.zip(tableView.rx.modelSelected(Notification.self), tableView.rx.itemSelected).bind { [weak self] (notification, indexPath) in
            guard let cell = self?.tableView.cellForRow(at: indexPath) as? NotificationCell else {
                return
            }
            cell.isSelected = false
            if !notification.is_checked {
                cell.isChecked()
                self?.check(notification: notification)
            }
            if let post = notification.post {
                self?.push(viewController: PostDetailViewController(post: post))
            }
        }.disposed(by: disposeBag)
    }
}

extension NotificationTabViewController {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.zero)
        var label = UILabel()

        if sections[section].model == "새로운 알림" {
            label = self.tabView.newNotificationLabel
        } else if sections[section].model == "이전 알림" {
            label = self.tabView.oldNotificationLabel
        }

        headerView.addSubview(label)
        headerView.backgroundColor = .white
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(headerView)
            make.left.equalTo(headerView).offset(16)
        }
        return headerView
    }
    
    private func configure(cell: NotificationCell, with notification: Notification) {
        cell.configure(with: notification)
        
        cell.detailButton.rx.tap.bind { [weak self] in
            self?.isShowingBottomSheet.accept(true)
        }.disposed(by: disposeBag)
    }
    
    private func check(notification: Notification) {
        NetworkService.get(endpoint: .notification(id: notification.id), as: Notification.self)
            .bind { [weak self] response in
                print(response)
            }.disposed(by: disposeBag)
    }
}
