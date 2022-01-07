//
//  NSLayoutConstraints+Activate.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/30.
//

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
    
    static func activateFourWayConstraints(subview: UIView, containerView: UIView, top: CGFloat?, leading: CGFloat?, bottom: CGFloat?, trailing: CGFloat?) {
        var constraints: [NSLayoutConstraint] = []
        if let top = top {
            constraints.append(subview.topAnchor.constraint(equalTo: containerView.topAnchor, constant: top))
        }
        if let leading = leading {
            constraints.append(subview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leading))
        }
        if let bottom = bottom {
            constraints.append(subview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: bottom))
        }
        if let trailing = trailing {
            constraints.append(subview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: trailing))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    static func activateCenterConstraints(subview: UIView, containerView: UIView) {
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
}
