//
//  RectangularSlimButton.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import UIKit
import SnapKit

class RectangularSlimButton: UIButton {
    
    private let buttonLabel = UILabel()
    private var buttonWidth: CGFloat = 0.0
    
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
        buttonLabel.textColor = color
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
        
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        buttonLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}
