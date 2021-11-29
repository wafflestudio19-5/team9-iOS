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
}
