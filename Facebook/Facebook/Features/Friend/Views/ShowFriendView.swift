//
//  ShowFriendView.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/14.
//

import UIKit

class ShowFriendView: UIView {
    
    let showFriendTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(showFriendTableView)
        showFriendTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        showFriendTableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.reuseIdentifier)
        showFriendTableView.allowsSelection = false
        showFriendTableView.delaysContentTouches = false
    }

}
