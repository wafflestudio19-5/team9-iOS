//
//  CommentModalView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/25.
//

import UIKit

class CommentModalView: PostDetailView {

    override func setLayout() {
        self.addSubview(commentTableView)
        commentTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        postContentHeaderView.snp.makeConstraints { make in
            make.width.equalTo(commentTableView.snp.width)
        }
    }

}
