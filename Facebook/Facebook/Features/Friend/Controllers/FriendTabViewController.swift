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
    
    init(isMain: Bool = true) {
        super.init(nibName: nil, bundle: nil)
        setNavigationBar(isMain: isMain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        friendRequestViewModel.refresh()
    }
    
    func setNavigationBar(isMain: Bool = true) {
        if isMain {
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            titleLabel.text = "친구"
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        } else {
            navigationItem.leftBarButtonItem = nil
            self.navigationItem.title = "친구"
        }
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
                            .subscribe { [weak self] event in
                                if event.isCompleted {
                                    return
                                }
                                
                                if event.element as? String != "수락 완료되었습니다." {
                                    self?.alert(title: "친구 요청 수락 오류", message: "요청을 수락하던 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                                } else {
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
                                    return
                                }
                                
                                if !(event.element is NSNull) {
                                    self?.alert(title: "친구 요청 거절 오류", message: "요청을 거절하던 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                                } else {
                                    cell.updateState(isAccepted: false)
                                }
                            }.disposed(by: self.disposeBag)
                    }.disposed(by: cell.refreshingBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] idxPath in
                self?.tableView.deselectRow(at: idxPath, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(FriendRequestCreate.self)
            .subscribe(onNext: { [weak self] friendRequest in
                let profileTabVC = ProfileTabViewController(userId: friendRequest.sender)
                self?.push(viewController: profileTabVC)
            }).disposed(by: disposeBag)
        
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


