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
    private let friendViewModel: PaginationViewModel<User>
    
    init(userId: Int) {
        self.userId = userId
        friendViewModel = PaginationViewModel<User>(endpoint: .friend(id: self.userId, limit: 20))
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
                
                cell.menuButton.rx.tap.bind { [weak self] in
                    print("menu button Tap!")
                }.disposed(by: cell.refreshingBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] idxPath in
                self?.tableView.deselectRow(at: idxPath, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(User.self)
            .subscribe(onNext: { [weak self] friend in
                print(friend.id)
                let profileTabVC = ProfileTabViewController(userId: friend.id, isFriend: true)
                self?.push(viewController: profileTabVC)
            }).disposed(by: disposeBag)
        
        showFriendView.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                //self.friendViewModel.dataList.accept(self.friendViewModel.dataList.value.filter { $0.username.contains(text) })
            }).disposed(by: disposeBag)
        
        /// `isLoading` 값이 바뀔 때마다 하단 스피너를 토글합니다.
        friendViewModel.isLoading
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
}

extension ShowFriendViewController {
    func showAlertFriendMenu() {
        let alertMenu = UIAlertController(title: "친구 관리", message: "", preferredStyle: .actionSheet)
        let showFriendsAction = UIAlertAction(title: "님의 친구 보기", style: .default) { action in
            print("asdf")
        }
        showFriendsAction.setValue(0, forKey: "titleTextAlignment")
        showFriendsAction.setValue(UIImage(systemName: "person.3.fill"), forKey: "image")
        
        let deleteFriendAction = UIAlertAction(title: "친구 끊기", style: .default, handler: { action in
            self.deleleFriend()
        })
        deleteFriendAction.setValue(0, forKey: "titleTextAlignment")
        deleteFriendAction.setValue(UIImage(systemName: "person.fill.xmark")!, forKey: "image")
        
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alertMenu.addAction(deleteFriendAction)
        alertMenu.addAction(cancelAction)
        
        self.present(alertMenu, animated: true, completion: nil)
    }
    
    func deleleFriend() {
//        let alert = UIAlertController(title: (userProfile?.username ?? "이 친구") + "님을 친구에서 삭제하시겠어요?", message: "",
//                                      preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
//        let deleteAction = UIAlertAction(title: "확인", style: .default) { action in
//            NetworkService.delete(endpoint: .friend(friendId: self.userId))
//                .subscribe { [weak self] event in
//                    guard let self = self else { return }
//                    if event.isCompleted {
//                        self.isFriend = false
//                        self.createSection()
//                    }
//                }.disposed(by: self.disposeBag)
//        }
//        alert.addAction(deleteAction)
//        self.present(alert, animated: true, completion: nil)
    }
}
