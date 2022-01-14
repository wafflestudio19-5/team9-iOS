//
//  ShowFriendView.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/14.
//

import UIKit

class ShowFriendView: UIView {
    
    let showFriendTableView = UITableView()
    let headerView = UIView()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
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
        self.addSubview(showFriendTableView)
        showFriendTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        headerView.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    private func configureTableView() {
        showFriendTableView.tableHeaderView = headerView
        showFriendTableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.reuseIdentifier)
        showFriendTableView.allowsSelection = false
        showFriendTableView.delaysContentTouches = false
    }

}
