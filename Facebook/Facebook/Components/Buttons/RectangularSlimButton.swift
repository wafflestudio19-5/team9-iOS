//
//  RectangularSlimButton.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import UIKit
import SnapKit

class RectangularSlimButton: UIButton {
    
    private var background: UIColor
    private var highlight: UIColor
    private var needsIndicator: Bool
    
    init(title: String, titleColor: UIColor, backgroundColor: UIColor, highlightColor: UIColor = .tintColors.blue, height: CGFloat = 40.0, titleSize: CGFloat = 16.0, needsIndicator: Bool = false) {
        self.background = backgroundColor
        self.highlight = highlightColor
        self.needsIndicator = needsIndicator
        super.init(frame: CGRect.zero)
        
        self.configuration = .plain()
        setButtonStyle()
        setButtonLabel(as: title, color: titleColor, size: titleSize)
        setLayoutForView(height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConfiguration() {
        switch self.state {
        case .highlighted:
            backgroundColor = highlight
            if needsIndicator {
                configuration?.showsActivityIndicator = true
            }
        default:
            backgroundColor = background
        }
    }
    
    func stopActivityIndicator() {
        configuration?.showsActivityIndicator = false
    }
    
    private func setButtonStyle() {
        self.layer.cornerRadius = 6.0
        configuration?.imagePlacement = .trailing
        configuration?.imagePadding = 10.0
    }
    
    private func setButtonLabel(as text: String, color: UIColor, size: CGFloat) {
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: size, weight: .semibold)
        configuration?.title = text
        configuration?.baseForegroundColor = color
        configuration?.attributedTitle = AttributedString(text, attributes: container)
    }
    
    private func setLayoutForView(height: CGFloat) {
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
}
