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
    
    private func baseConfigure(symbolName: String, text: String) {
        configuration?.imagePadding = 5
        configuration?.image = getImage(name: symbolName)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayscales.border.cgColor
        self.text = text
    }
    
    func configurePublic() {
        baseConfigure(symbolName: "globe.asia.australia.fill", text: "전체 공개")
    }
    
    func configureFriendsOnly() {
        baseConfigure(symbolName: "person.2.fill", text: "친구만")
    }
    
    func configurePrivate() {
        baseConfigure(symbolName: "lock.fill", text: "나만 보기")
    }

}
