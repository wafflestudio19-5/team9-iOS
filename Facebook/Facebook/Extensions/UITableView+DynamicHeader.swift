//
//  UITableView+DynamicHeader.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/04.
//

import Foundation
import UIKit


extension UITableView {
    /// `tableHeaderView`의 높이를 다이나믹하게 조절한다.
    func adjustHeaderHeight() {
        if let headerView = self.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            
            // Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                self.tableHeaderView = headerView
            }
        }
    }
}
