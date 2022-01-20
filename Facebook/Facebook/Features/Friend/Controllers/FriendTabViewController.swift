//
//  FriendTabViewController.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/13.
//

import UIKit
import RxSwift
import RxCocoa


class FriendTabViewController: BaseTabViewController<FriendTabView> {

    var tableView: UITableView {
        tabView.friendTableView
    }
    
    let friendRequestViewModel = PaginationViewModel<FriendRequestCreate>(endpoint: .friendRequest())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bind()
    }
    
    func bind() {
        friendRequestViewModel.dataList
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: FriendRequestCell.reuseIdentifier, cellType: FriendRequestCell.self)) { [weak self] row, requestFriend, cell in
                guard let self = self else { return }
                cell.configureCell(with: requestFriend.sender_profile)
                
                cell.acceptButton.rx.tap
                    .bind { [weak self] _ in
                        guard let self = self else { return }
                        NetworkService.put(endpoint: .friendRequest(id: requestFriend.sender))
                            .subscribe { event in
                                if event.isCompleted {
                                    cell.updateState(isAccepted: true)
                                }
                            }.disposed(by: self.disposeBag)
                    }.disposed(by: cell.refreshingBag)
                
                cell.deleteButton.rx.tap
                    .bind { [weak self] _ in
                        guard let self = self else { return }
                        NetworkService.delete(endpoint: .friendRequest(id: requestFriend.sender))
                            .subscribe { [weak self] event in
                                if event.isCompleted {
                                    cell.updateState(isAccepted: false)
                                    return
                                }
                            }.disposed(by: self.disposeBag)
                    }.disposed(by: cell.refreshingBag)
            }
            .disposed(by: disposeBag)
        
        tabView.showFriendButton.rx.tap
            .bind { [weak self] _ in
                let showFriendViewController = ShowFriendViewController(userId: StateManager.of.user.profile.id)
                self?.push(viewController: showFriendViewController)
            }
            .disposed(by: disposeBag)
        
        friendRequestViewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.tableView.showBottomSpinner()
                } else {
                    self?.tableView.hideBottomSpinner()
                    self?.setTableViewBackground()
                }
            })
            .disposed(by: disposeBag)
        
        /// 새로고침 제스쳐가 인식될 때마다 `refresh` 함수를 실행합니다.
        tabView.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.friendRequestViewModel.refresh()
            })
            .disposed(by: disposeBag)
        
        /// 새로고침이 완료될 때마다 `refreshControl`의 애니메이션을 중단시킵니다.
        friendRequestViewModel.refreshComplete
            .asDriver(onErrorJustReturn: false)
            .drive(onNext : { [weak self] refreshComplete in
                if refreshComplete {
                    self?.tabView.refreshControl.endRefreshing()
                    self?.setTableViewBackground()
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
                    self.friendRequestViewModel.loadMore()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func setTableViewBackground() {
        if self.friendRequestViewModel.dataList.value.count == 0 {
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.backgroundView?.isHidden = true
        }
    }
}
