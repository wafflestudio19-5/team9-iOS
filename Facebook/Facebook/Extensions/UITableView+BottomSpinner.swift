//
//  UITableView+BottomSpinner.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/05.
//

import Foundation
import UIKit


extension UITableView {
    /// `tableHeaderView`의 높이를 다이나믹하게 조절한다.
    func showBottomSpinner() {
        tableFooterView = Spinner(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 100))
    }
    
    func hideBottomSpinner() {
        tableFooterView = UIView(frame: .zero)
    }
}
