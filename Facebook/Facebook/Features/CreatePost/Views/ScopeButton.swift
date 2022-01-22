//
//  ScopeButton.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/21.
//

import UIKit

class ScopeButton: InfoButton {
    
    private func getImage(name: String) -> UIImage {
        return UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .regular))!
    }
    
    func configure(with scope: Scope) {
        configuration?.imagePadding = 5
        configuration?.image = scope.getImage(fill: true)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayscales.border.cgColor
        self.text = scope.text
    }
}
