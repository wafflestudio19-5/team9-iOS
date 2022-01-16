//
//  FacebookTextField.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import UIKit
import SnapKit

class FacebookTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: CGRect.zero)
        setStyleForView(placeholderText: placeholderText)
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView(placeholderText: String) {
        self.placeholder = placeholderText
        self.clearButtonMode = .whileEditing
        self.autocorrectionType = .no
        self.borderStyle = .roundedRect
    }
    
    private func setLayoutForView() {
        self.snp.makeConstraints { make in
            make.height.equalTo(42.0)
        }
    }
}
