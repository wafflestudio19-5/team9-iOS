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

class NotificationTabViewController: BaseTabViewController<NotificationTabView>, UITableViewDelegate, UIScrollViewDelegate {

    var tableView: UITableView {
        tabView.notificationTableView
    }
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Notification>>(configureCell: configureCell)

    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionModel<String, Notification>>.ConfigureCell = { [weak self] dataSource, tableView, indexPath, notification in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier, for: indexPath) as? NotificationCell else { return UITableViewCell() }
        cell.configure(with: notification)
        cell.detailButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.didTapDeleteButton(notification: notification)
        }.disposed(by: self!.disposeBag)
        
        return cell
    }
    
    private let isShowingBottomSheet: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let viewModel = NotificationPaginationViewModel(endpoint: .notification())
    
    /// 새로운 알림, 이전 알림
    private let oldNotifications = BehaviorRelay<[Notification]>(value: [])
    private let newNotifications = BehaviorRelay<[Notification]>(value: [])
    
    private let sectionList = BehaviorRelay<[SectionModel<String, Notification>]>(value: [])
    private var sections: [SectionModel<String, Notification>] = []
    
//    private let menu = [ Menu(image: UIImage(systemName: "xmark.rectangle.fill") ?? UIImage(),
//                              text: "이 알림 삭제",
//                              action: { print("button tapped") }),
//                         Menu(image: UIImage(systemName: "bell.slash.fill") ?? UIImage(),
//                              text: "알림 해제",
//                              action: { print("button tapped") })]
//
//    private var bottomSheetViewController = UIViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tabView.largeTitleLabel)
        
//        bottomSheetViewController = BottomSheetViewController(menuList: self.menu)
//        bottomSheetViewController.modalPresentationStyle = .overFullScreen
        
        bind()
    }
    
    private func bind() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        StateManager.of.notification.bind(with: viewModel.dataList).disposed(by: disposeBag)
        
        viewModel.dataList
            .observe(on: MainScheduler.instance)
            .bind { [weak self] notification in
                guard let self = self else { return }
                
                self.oldNotifications.accept(notification.filter { $0.is_checked })
                self.newNotifications.accept(notification.filter { !$0.is_checked })
                
                self.sectionList.accept([])
                self.sections.removeAll()
                
                if !self.newNotifications.value.isEmpty { self.sections.append(SectionModel(model: "새로운 알림", items: self.newNotifications.value)) }
                if !self.oldNotifications.value.isEmpty { self.sections.append(SectionModel(model: "이전 알림", items: self.oldNotifications.value)) }

                self.sectionList.accept(self.sections)
            }.disposed(by: disposeBag)
        
        sectionList
            .bind(to: tableView.rx.items(dataSource: dataSource))
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
        
//        tabView.rx.tapGesture().bind { [weak self] _ in
//            guard let self = self else { return }
//            print("touch recognized")
//            if self.isShowingBottomSheet.value {
//                self.isShowingBottomSheet.accept(false)
//            }
//        }.disposed(by: disposeBag)
//
//        isShowingBottomSheet
//            .observe(on: MainScheduler.instance)
//            .bind { [weak self] isShowing in
//                guard let self = self else { return }
//
//            }.disposed(by: disposeBag)

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
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewWithTitle.reuseIdentifier) as? HeaderViewWithTitle else {
            return UITableViewHeaderFooterView()
        }
        
        if sections[section].model == "새로운 알림" {
            header.setTitle(as: "새로운 알림")
        } else {
            header.setTitle(as: "이전 알림")
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    private func configure(cell: NotificationCell, with notification: Notification) {
        cell.configure(with: notification)
        
        cell.detailButton.rx.tap.bind { [weak self] in
            self?.isShowingBottomSheet.accept(true)
        }.disposed(by: disposeBag)
    }
    
    // 알림 확인
    private func check(notification: Notification) {
        NetworkService.get(endpoint: .notification(id: notification.id), as: Notification.self)
            .bind { response in
                StateManager.of.notification.dispatch(check: response.1)
            }.disposed(by: disposeBag)
    }
    
    // 알림 삭제
    private func delete(notification: Notification) {
        NetworkService.delete(endpoint: .notification(id: notification.id))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                StateManager.of.notification.dispatch(delete: notification, at: self.viewModel.findDeletionIndex(of: notification))
            }).disposed(by: disposeBag)
    }
    
    private func didTapDeleteButton(notification: Notification) {
        let alert = UIAlertController(title: "알림 삭제",
                                      message: "알림을 삭제하시겠습니까?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.delete(notification: notification)
        })
        self.present(alert, animated: true, completion: nil)
    }
}
