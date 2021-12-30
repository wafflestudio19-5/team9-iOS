//
//  ProfileTabView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class ProfileTabView: UIView {

    let profileTableView = UITableView()
    let refreshControl = UIRefreshControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(profileTableView)
        
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            profileTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureTableView() {
        profileTableView.tableHeaderView = UIView()  // removes the separator at the top
        profileTableView.register(UINib(nibName: "MainProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "MainProfileCell")
        profileTableView.register(SimpleInformationTableViewCell.self, forCellReuseIdentifier: SimpleInformationTableViewCell.reuseIdentifier)
        profileTableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier)
        profileTableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        profileTableView.allowsSelection = false
        profileTableView.refreshControl = refreshControl
    }
    
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
        self.profileTableView.tableFooterView = self.bottomSpinner
    }
    
    func hideBottomSpinner() {
        self.profileTableView.tableFooterView = UIView(frame: .zero)
    }
}
