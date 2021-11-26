//
//  NewsfeedTabView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class NewsfeedTabView: UIView {
    
    let newsfeedTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewComponents() {
        self.addSubview(newsfeedTableView)
        
        newsfeedTableView.translatesAutoresizingMaskIntoConstraints = false
        newsfeedTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        newsfeedTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        newsfeedTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        newsfeedTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
