//
//  SubPostsView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/11.
//

import UIKit

class SubPostsView: UIView {
    
    var post: Post
    var subpostsTableView = ResponsiveTableView()
    
    init(post: Post) {
        self.post = post
        super.init(frame: .zero)
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mainPostHeader: UIView = {
        let postCell = PostCell()
        postCell.configureCell(with: post)
        return postCell.contentView
    }()
    
    func setTableView() {
        self.addSubview(subpostsTableView)
//        subpostsTableView.tableHeaderView = mainPostHeader
        subpostsTableView.register(SubPostCell.self, forCellReuseIdentifier: SubPostCell.reuseIdentifier)
        subpostsTableView.separatorStyle = .none
        subpostsTableView.rowHeight = UITableView.automaticDimension
        subpostsTableView.estimatedRowHeight = 300
        subpostsTableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
//        mainPostHeader.snp.makeConstraints { make in
//            make.width.equalTo(subpostsTableView)
//        }
    }

}
