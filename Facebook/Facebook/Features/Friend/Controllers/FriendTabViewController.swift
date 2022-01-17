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
            }
            .disposed(by: disposeBag)
        
        tabView.showFriendButton.rx.tap
            .bind { [weak self] _ in
                let showFriendViewController = ShowFriendViewController(userId: StateManager.of.user.profile.id)
                self?.push(viewController: showFriendViewController)
            }
            .disposed(by: disposeBag)
    }
}
