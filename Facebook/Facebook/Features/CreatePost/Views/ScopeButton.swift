//
//  ScopeButton.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/21.
//

import UIKit

class ScopeButton: InfoButton {
    
    private func getImage(name: String) -> UIImage {
        return UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .regular))!
    }
    
    func configurePublic() {
        configuration?.image = getImage(name: "globe.asia.australia.fill")
        configuration?.imagePadding = 5
        self.text = "전체 공개"
    }
    func configureFriendsOnly() {
        configuration?.image = getImage(name: "person.2.fill")
        configuration?.imagePadding = 5
        self.text = "친구만"
    }
    func configurePrivate() {
        configuration?.image = getImage(name: "lock.fill")
        configuration?.imagePadding = 5
        self.text = "나만 보기"
    }

}
