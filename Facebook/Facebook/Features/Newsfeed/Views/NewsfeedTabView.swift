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
        newsfeedTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsfeedTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            newsfeedTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            newsfeedTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            newsfeedTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureTableView() {
        newsfeedTableView.tableHeaderView = mainTableHeaderView
        mainTableHeaderView.widthAnchor.constraint(equalTo: newsfeedTableView.widthAnchor).isActive = true
        
        newsfeedTableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        newsfeedTableView.allowsSelection = false
        newsfeedTableView.refreshControl = refreshControl
        newsfeedTableView.delaysContentTouches = false
        newsfeedTableView.separatorStyle = .none
    }
}
