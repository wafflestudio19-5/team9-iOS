//
//  PostView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/05.
//

import UIKit
import KakaoSDKCommon

class PostDetailView: UIView {
    
    let commentTableView = UITableView()
    let postContentHeaderView = PostContentHeaderView()
    
    var likeButton: LikeButton {
        postContentHeaderView.buttonStackView.likeButton
    }
    
    var commentButton: CommentButton {
        postContentHeaderView.buttonStackView.commentButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        self.addSubview(commentTableView)
        commentTableView.tableHeaderView = postContentHeaderView
        commentTableView.register(UINib(nibName: "PostContentTableViewCell", bundle: nil), forCellReuseIdentifier: "PostContentCell")
        commentTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        commentTableView.allowsSelection = false
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            commentTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            commentTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
    
        ])
    }
}
