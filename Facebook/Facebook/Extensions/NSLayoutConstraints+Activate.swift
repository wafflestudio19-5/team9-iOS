//
//  NSLayoutConstraints+Activate.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/30.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    static func activateFourWayConstraints(subview: UIView, containerView: UIView) {
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            subview.topAnchor.constraint(equalTo: containerView.topAnchor),
            subview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    static func activateCenterConstraints(subview: UIView, containerView: UIView) {
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
}
