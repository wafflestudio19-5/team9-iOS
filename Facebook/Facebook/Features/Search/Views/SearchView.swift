//
//  SearchView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/13.
//

import Foundation
import UIKit

class SearchView: UIView {
    
    let tableView = ResponsiveTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTableView() {
        self.addSubview(tableView)
    }
    
}
