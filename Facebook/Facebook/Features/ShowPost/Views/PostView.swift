//
//  PostView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/05.
//

import UIKit
import KakaoSDKCommon

class PostView: UIView {

    let postTableView = UITableView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView() {
        postTableView.register(UINib(nibName: "PostContentTableViewCell", bundle: nil), forCellReuseIdentifier: "PostContentCell")
        postTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        postTableView.allowsSelection = false
    }
    
    private func setLayoutForView() {
        self.addSubview(postTableView)
        
        postTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            postTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            postTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            postTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
    
        ])
    }
}
