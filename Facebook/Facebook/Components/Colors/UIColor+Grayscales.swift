//
//  FacebookGrayscale.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/21.
//

import UIKit

extension UIColor {
    struct grayscales {
        /// background gray color (for newsfeed divider)
        static var newsfeedDivider = UIColor(named: "NewsfeedDivider")!
        
        /// 1px border gray color
        static var border = UIColor.opaqueSeparator.withAlphaComponent(0.5)
        
        /// 댓글, 말풍선에 사용되는 회색
        static var bubble = UIColor.tertiarySystemGroupedBackground.withAlphaComponent(0.7)
        static var bubbleFocused = UIColor.systemGray5
        
        /// dark gray 색상 대신 사용
        static var label = UIColor.secondaryLabel.withAlphaComponent(0.8)
        
        /// 이미지 가장자리에 적용하는 색상
        static var imageBorder = UIColor(named: "ImageBorder")!
        
        /// 회색 계열 버튼에 사용되는 회색
        static var button = UIColor(red: 227.0/255.0, green: 228.0/255.0, blue: 235.0/255.0, alpha: 1.0)
    }
}
