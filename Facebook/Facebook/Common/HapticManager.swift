//
//  HapticManager.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/07.
//

import Foundation
import UIKit

struct HapticManager {
    static var shared = HapticManager()
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
