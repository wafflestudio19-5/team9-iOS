//
//  SubPostCaptionView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/27.
//

import UIKit

class SubPostCaptionView: UIView {
    
    var subpostsTableView = ResponsiveTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTableView() {
        self.addSubview(subpostsTableView)
        subpostsTableView.backgroundColor = .grayscales.newsfeedDivider
        subpostsTableView.register(SubPostCaptionCell.self, forCellReuseIdentifier: SubPostCaptionCell.reuseIdentifier)
        subpostsTableView.separatorStyle = .none
        subpostsTableView.allowsSelection = false
        subpostsTableView.keyboardDismissMode = .interactive
        subpostsTableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }

}
