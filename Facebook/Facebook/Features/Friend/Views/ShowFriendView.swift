//
//  ShowFriendView.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/14.
//

import UIKit

class ShowFriendView: UIView {
    
    let showFriendTableView = UITableView()
    let refreshControl = UIRefreshControl()
    let headerView = UIView()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .systemGray5
        searchBar.placeholder = "친구 검색"
        
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        headerView.frame = CGRect(x: 0, y: 0, width: showFriendTableView.frame.width, height: 70)
        headerView.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        self.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.addSubview(showFriendTableView)
        showFriendTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        showFriendTableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.reuseIdentifier)
        showFriendTableView.refreshControl = refreshControl
        showFriendTableView.delaysContentTouches = false
    }

}
