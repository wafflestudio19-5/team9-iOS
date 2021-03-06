//
//  ResponsiveTableView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/03.
//

import Foundation
import UIKit

/// 테이블뷰 안에 버튼이 존재하는 경우
/// 스크롤에 지장을 주지 않으면서 버튼의 반응속도를 빠르게 한다.
class ResponsiveTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delaysContentTouches = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}

class ResponsiveScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delaysContentTouches = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
