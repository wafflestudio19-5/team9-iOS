//
//  FacebookGrayscale.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/21.
//

import Foundation
import UIKit

extension UIColor {
    struct Grayscales {
        /// background gray color (for newsfeed divider)
        static var gray1 = UIColor(red: 211/255.0, green: 214/255.0, blue: 216/255.0, alpha: 1)
        
        /// 1px border gray color
        static var gray2 = UIColor.gray.withAlphaComponent(0.2)
        
        static var gray3 = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    }
}
