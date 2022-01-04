//
//  PostView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/05.
//

import UIKit
import KakaoSDKCommon

class PostDetailView: UIView {
    
    let commentTableView = ResponsiveTableView()
    let postContentHeaderView = PostDetailHeaderView()
    var tableViewBottomConstraint: NSLayoutConstraint?
    
    var likeButton: LikeButton {
        postContentHeaderView.buttonStackView.likeButton
    }
    
    var commentButton: CommentButton {
        postContentHeaderView.buttonStackView.commentButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        self.addSubview(commentTableView)
        commentTableView.tableHeaderView = postContentHeaderView
        commentTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        commentTableView.allowsSelection = false
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.delaysContentTouches = false
        commentTableView.keyboardDismissMode = .interactive
        tableViewBottomConstraint = commentTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableViewBottomConstraint!,
//            commentTableView.heightAnchor.constraint(equalToConstant: 40),
            commentTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            postContentHeaderView.widthAnchor.constraint(equalTo: commentTableView.widthAnchor)
        ])
    }
}
