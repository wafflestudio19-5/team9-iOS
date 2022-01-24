//
//  NewsfeedTabView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class NewsfeedTabView: UIView {
    
    let newsfeedTableView = ResponsiveTableView()
    let refreshControl = UIRefreshControl()
    let mainTableHeaderView = MainHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(newsfeedTableView)
        newsfeedTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        newsfeedTableView.tableHeaderView = mainTableHeaderView
        mainTableHeaderView.widthAnchor.constraint(equalTo: newsfeedTableView.widthAnchor).isActive = true
        
        newsfeedTableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        newsfeedTableView.allowsSelection = false
        newsfeedTableView.refreshControl = refreshControl
        newsfeedTableView.separatorStyle = .none
    }
}
