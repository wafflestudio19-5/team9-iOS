//
//  ProfileTabView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class ProfileTabView: UIView {

    let profileTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        setStyleForView()
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
    
    private func setStyleForView() {
        //profileTableView.tableHeaderView = UIView()  // removes the separator at the top
        profileTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        profileTableView.register(UINib(nibName: "CreatePostTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatePostCell")
        profileTableView.register(UINib(nibName: "MainProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "MainProfileCell")
        profileTableView.register(UINib(nibName: "DetailProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailProfileCell")
        profileTableView.register(UINib(nibName: "ShowProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowProfileCell")
        profileTableView.register(UINib(nibName: "EditProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileCell")
        profileTableView.allowsSelection = false
    }
}
