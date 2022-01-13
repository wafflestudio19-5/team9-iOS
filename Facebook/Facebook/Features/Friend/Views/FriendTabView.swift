//
//  FriendTabView.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/13.
//

import UIKit

class FriendTabView: UIView {

    let friendTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(friendTableView)
        friendTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        friendTableView.allowsSelection = false
        friendTableView.delaysContentTouches = false
    }

}
