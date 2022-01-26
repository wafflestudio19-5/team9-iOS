//
//  ProfileTabView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class ProfileTabView: UIView {

    let profileTableView = ResponsiveTableView(frame: .zero, style: .grouped)
    let refreshControl = UIRefreshControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        profileTableView.backgroundColor = .white
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(profileTableView)
        profileTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        profileTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        profileTableView.separatorStyle = .none
        profileTableView.register(UINib(nibName: "MainProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "MainProfileCell")
        profileTableView.register(SimpleInformationTableViewCell.self, forCellReuseIdentifier: SimpleInformationTableViewCell.reuseIdentifier)
        profileTableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier)
        profileTableView.register(FriendCollectionTableViewCell.self, forCellReuseIdentifier: FriendCollectionTableViewCell.reuseIdentifier)
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
