//
//  FacebookTextField.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import RxSwift

class FacebookTextField: UITextField {
    
    init(placeholderText: String, width: CGFloat) {
        super.init(frame: CGRect.zero)
        setStyleForView(placeholderText: placeholderText)
        setLayoutForView(width: width)
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
    
    private func setLayoutForView(width: CGFloat) {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 42.0),
            self.widthAnchor.constraint(equalToConstant: width),
        ])
    }
}

func pushViewController(viewController: UIViewController) {
    
}
