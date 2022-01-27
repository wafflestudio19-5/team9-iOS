//
//  FriendTabView.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/13.
//

import UIKit

class FriendTabView: UIView {

    let friendTableView = UITableView()
    let refreshControl = UIRefreshControl()
    let headerView = UIView()
    let showFriendButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17.5
        button.backgroundColor = .systemGray4
        button.setTitle("내 친구", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return button
    }()
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        
        return view
    }()
    
    let emptyBackgroundView = EmptyBackgroundView(image: UIImage(systemName: "exclamationmark.bubble.fill") ?? UIImage(), title: "표시할 친구 요청 없음", message: "다른 사람들로부터 받은 친구 요청이 없습니다.")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        headerView.frame = CGRect(x: 0, y: 0, width: friendTableView.frame.width, height: 45)
        headerView.addSubview(showFriendButton)
        showFriendButton.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.width.equalTo(70)
            make.top.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(15)
        }
        headerView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        }
        
        self.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.top.left.right.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.addSubview(friendTableView)
        friendTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.left.right.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        friendTableView.backgroundView = emptyBackgroundView
        emptyBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(friendTableView).priority(999)
        }
        friendTableView.separatorStyle = .none
        friendTableView.register(FriendRequestCell.self, forCellReuseIdentifier: FriendRequestCell.reuseIdentifier)
        friendTableView.refreshControl = refreshControl
        friendTableView.delaysContentTouches = false
    }

}
