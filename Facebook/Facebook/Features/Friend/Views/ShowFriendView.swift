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
        searchBar.backgroundColor = .white
        searchBar.searchTextField.backgroundColor = .systemGray5
        searchBar.placeholder = "친구 검색"
        
        return searchBar
    }()
    let emptyBackgroundView = EmptyBackgroundView(image: UIImage(systemName: "person.fill.questionmark") ?? UIImage(), title: "표시할 친구 없음", message: "검색 결과가 없습니다.")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        headerView.backgroundColor = .white
        headerView.frame = CGRect(x: 0, y: 0, width: showFriendTableView.frame.width, height: 70)
        headerView.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        self.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.addSubview(showFriendTableView)
        showFriendTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        showFriendTableView.backgroundView = emptyBackgroundView
        emptyBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(showFriendTableView).priority(999)
        }
        showFriendTableView.separatorStyle = .none
        showFriendTableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.reuseIdentifier)
        showFriendTableView.refreshControl = refreshControl
        showFriendTableView.delaysContentTouches = false
    }

}
