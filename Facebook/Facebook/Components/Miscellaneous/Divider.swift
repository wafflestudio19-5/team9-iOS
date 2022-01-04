//
//  Divider.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/04.
//

import UIKit

class Divider: UIView {
    
    convenience init(color: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = color
    }

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .Grayscales.gray2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
