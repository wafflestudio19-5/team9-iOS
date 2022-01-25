//
//  ShowFriendViewController.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/14.
//

import UIKit
import RxSwift
import RxCocoa

class ShowFriendViewController<View: ShowFriendView>: UIViewController {

    override func loadView() {
        view = View()
    }

    var showFriendView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    var tableView: UITableView {
        showFriendView.showFriendTableView
    }
    
    let disposeBag = DisposeBag()
    
    private let userId: Int
    private let friendViewModel: FriendPaginationViewModel
    
    init(userId: Int) {
        self.userId = userId
        friendViewModel = FriendPaginationViewModel(endpoint: .friend(id: self.userId, limit: 20))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bind()
    }
    
    private func bind() {
        friendViewModel.dataList.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: FriendCell.reuseIdentifier, cellType: FriendCell.self)) { [weak self] row, friend, cell in
                guard let self = self else { return }
                cell.configureCell(with: friend)
                cell.setButtonStyle(friendInfo: friend.friend_info ?? "self")
                
                cell.button.rx.tap.bind { [weak self] in
                    guard let self = self else { return }
                    
                    switch friend.friend_info {
                    case "self":
                        break
                    case "friend":
                        let menuList = self.createFriendMenuList(cell: cell, friend: friend)
                        let bottomSheetVC = BottomSheetViewController(menuList: menuList)
                        bottomSheetVC.modalPresentationStyle = .overFullScreen
                        self.present(bottomSheetVC, animated: false, completion: nil)
                    case "sent":
                        self.deleteFriendRequest(friendId: friend.id)
                        cell.setButtonStyle(friendInfo: "nothing")
                    case "received":
                        let menuList = self.createResponseMenuList(cell: cell, friend: friend)
                        let bottomSheetVC = BottomSheetViewController(menuList: menuList)
                        bottomSheetVC.modalPresentationStyle = .overFullScreen
                        self.present(bottomSheetVC, animated: false, completion: nil)
                    case "nothing":
                        self.friendRequest(friendId: friend.id)
                        cell.setButtonStyle(friendInfo: "sent")
                    default :
                        break
                    }
                }.disposed(by: cell.refreshingBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] idxPath in
                self?.tableView.deselectRow(at: idxPath, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(User.self)
            .subscribe(onNext: { [weak self] friend in
                let profileTabVC = ProfileTabViewController(userId: friend.id)
                self?.push(viewController: profileTabVC)
            }).disposed(by: disposeBag)
        
        showFriendView.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] key in
                guard let self = self else { return }
                
                if key != "" {
                    self.friendViewModel.searchFriend(key: key)
                } else {
                    self.friendViewModel.refresh()
                }
                
                self.setTableViewBackground()
            }).disposed(by: disposeBag)
        
        /// `isLoading` 값이 바뀔 때마다 하단 스피너를 토글합니다.
        friendViewModel.isLoading
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
        showFriendView.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.friendViewModel.refresh()
            })
            .disposed(by: disposeBag)
        
        /// 새로고침이 완료될 때마다 `refreshControl`의 애니메이션을 중단시킵니다.
        friendViewModel.refreshComplete
            .asDriver(onErrorJustReturn: false)
            .drive(onNext : { [weak self] refreshComplete in
                if refreshComplete {
                    self?.showFriendView.refreshControl.endRefreshing()
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
                    self.friendViewModel.loadMore()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func setTableViewBackground() {
        if self.friendViewModel.dataList.value.count == 0 {
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.backgroundView?.isHidden = true
        }
    }
    
}

extension ShowFriendViewController {
    func createFriendMenuList(cell: FriendCell, friend: User) -> [Menu] {
        let menuList = [ Menu(image: UIImage(systemName: "person.2.fill") ?? UIImage(),
                              text: friend.username + "님의 친구 보기", action: {
            let showFriendVC = ShowFriendViewController(userId: friend.id)
            self.push(viewController: showFriendVC)
        }),
                         Menu(image: UIImage(systemName: "person.fill.xmark") ?? UIImage(),
                              text: friend.username + "님과 친구 끊기", action: {
            self.deleleFriend(friend: friend)
            cell.setButtonStyle(friendInfo: "nothing")
        })]
        
        return menuList
    }
    
    func createResponseMenuList(cell: FriendCell, friend: User) -> [Menu] {
        let menuList = [ Menu(image: UIImage(systemName: "person.fill.checkmark") ?? UIImage(),
                              text: "친구 요청 수락", action: {
            self.acceptFriendRequest(friendId: friend.id)
            cell.setButtonStyle(friendInfo: "friend")
        }),
                         Menu(image: UIImage(systemName: "person.fill.xmark") ?? UIImage(),
                              text: "친구 요청 거절", action: {
            self.deleteFriendRequest(friendId: friend.id)
            cell.setButtonStyle(friendInfo: "nothing")
        })]
        
        return menuList
    }
}


extension ShowFriendViewController {
    //친구 요청
    func friendRequest(friendId: Int) {
        NetworkService.post(endpoint: .friendRequest(id: friendId), as: FriendRequestCreate.self)
            .subscribe { [weak self] event in
                guard let self = self else { return }
                
                if event.isCompleted {
                    return
                }
                
                if event.element?.1 == nil {
                    self.alert(title: "친구 요청 오류", message: "요청 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                } else {
                    self.friendViewModel.refresh()
                }
            }.disposed(by: self.disposeBag)
    }
    
    func acceptFriendRequest(friendId: Int) {
        NetworkService.put(endpoint: .friendRequest(id: friendId))
            .subscribe { [weak self] event in
                guard let self = self else { return }
                
                if event.isCompleted {
                    return
                }
                
                if event.element as? String != "수락 완료되었습니다." {
                    self.alert(title: "친구 요청 수락 오류", message: "요청을 수락하던 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                } else {
                    self.friendViewModel.refresh()
                }
            }.disposed(by: self.disposeBag)
    }
    
    func deleteFriendRequest(friendId: Int) {
        NetworkService.delete(endpoint: .friendRequest(id: friendId))
            .subscribe{ [weak self] event in
                guard let self = self else { return }
                
                if event.isCompleted {
                    return
                }
                
                if !(event.element is NSNull) {
                    self.alert(title: "친구 요청 취소 오류", message: "요청을 취소하던 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                } else {
                    self.friendViewModel.refresh()
                }
            }.disposed(by: self.disposeBag)
    }
    
    func deleleFriend(friend: User) {
        let alert = UIAlertController(title: friend.username + "님을 친구에서 삭제하시겠어요?", message: "",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        let deleteAction = UIAlertAction(title: "확인", style: .default) { action in
            NetworkService.delete(endpoint: .friend(friendId: friend.id))
                .subscribe { [weak self] event in
                    guard let self = self else { return }
                    
                    if event.isCompleted {
                        return
                    }
                    
                    if !(event.element is NSNull) {
                        self.alert(title: "친구 요청 취소 오류", message: "요청을 취소하던 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                    } else {
                        self.friendViewModel.refresh()
                    }
                }.disposed(by: self.disposeBag)
        }
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
}
