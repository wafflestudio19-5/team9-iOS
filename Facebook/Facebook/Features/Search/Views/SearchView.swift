//
//  SearchView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/13.
//

import UIKit

class SearchView: UIView {
    
    let tableView = ResponsiveTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTableView() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
    }
}
