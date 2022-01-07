//
//  NewsfeedTableView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/08.
//

import Foundation
import UIKit

class NewsfeedTableView: ResponsiveTableView {
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
//        print(view)
//        if view is AuthorInfoHeaderView {
//            return true
//        }
        return super.touchesShouldCancel(in: view)
    }
}
