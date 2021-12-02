//
//  RectangularSlimButton.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import UIKit

class RectangularSlimButton: UIButton {
    
    private let buttonLabel = UILabel()
    
    init(title: String, titleColor: UIColor, backgroundColor: UIColor) {
        super.init(frame: CGRect.zero)
        
        setButtonLabel(as: title)
        setButtonBackgroundColor(as: backgroundColor)
        setButtonTextColor(as: titleColor)
        setLayoutForView()
        self.layer.cornerRadius = 6.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeLabelTextColor(to color: UIColor) {
        self.buttonLabel.textColor = color
    }
    
    private func setButtonLabel(as text: String) {
        buttonLabel.text = text
        buttonLabel.font = .systemFont(ofSize: 16.0, weight: .semibold)
    }
    
    private func setButtonBackgroundColor(as color: UIColor) {
        self.backgroundColor = color
    }
    
    private func setButtonTextColor(as color: UIColor) {
        self.buttonLabel.textColor = color
    }
    
    private func setLayoutForView() {
        self.addSubview(buttonLabel)
        
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 40.0),
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32.0),
            
            buttonLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
