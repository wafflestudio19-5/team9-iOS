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
        friendViewModel = PaginationViewModel<User>(endpoint: .friend(id: self.userId))
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
                
            }
            .disposed(by: disposeBag)
    }

}
