//
//  NewsfeedTabView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class NewsfeedTabView: UIView {
    
    let newsfeedTableView = UITableView()
    let refreshControl = UIRefreshControl()
    let createPostHeaderView = CreatePostHeaderView()
    
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
        newsfeedTableView.tableHeaderView = createPostHeaderView
        createPostHeaderView.widthAnchor.constraint(equalTo: newsfeedTableView.widthAnchor).isActive = true
        
        newsfeedTableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        newsfeedTableView.allowsSelection = false
        newsfeedTableView.refreshControl = refreshControl
    }
    
    // MARK: Bottom Spinner
    
    private lazy var bottomSpinner: UIView = {
        let view = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: self.frame.size.width,
            height: 100)
        )
        let spinner = UIActivityIndicatorView()
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.startAnimating()
        return view
    }()
    
    func showBottomSpinner() {
        self.newsfeedTableView.tableFooterView = self.bottomSpinner
    }
    
    func hideBottomSpinner() {
        self.newsfeedTableView.tableFooterView = UIView(frame: .zero)
    }
}
