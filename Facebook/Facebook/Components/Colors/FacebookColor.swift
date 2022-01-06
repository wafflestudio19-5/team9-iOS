//
//  FacebookColor.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import UIKit

enum FacebookColor {
    case deepBlue
    case mediumBlue
    case blue
    case mildBlue
    
    func color() -> UIColor {
        switch self {
        case .deepBlue: return UIColor(red: 4.0 / 255.0, green: 60.0 / 255.0, blue: 133.0 / 255.0, alpha: 1.0)
        case .mediumBlue: return UIColor(red: 0.0 / 255.0, green: 87.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
        case .blue: return UIColor(red: 22.0 / 255.0, green: 116.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0)
        case .mildBlue: return UIColor(red: 231.0 / 255.0, green: 242.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
        }
    }
}
