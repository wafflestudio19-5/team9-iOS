//
//  InfoButton.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/05.
//

import UIKit

/// 라벨같이 생겼으나 알고보면 버튼인 것들.
/// 좋아요, 답글 달기, 댓글 수 등등에 사용
class InfoButton: UIButton {
    
    var text: String = "" {
        didSet {
            self.configuration?.attributedTitle = AttributedString(text, attributes: attributeContainer)
        }
    }
    
    var color: UIColor
    var size: CGFloat
    var weight: UIFont.Weight
    
    private var attributeContainer: AttributeContainer {
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: size, weight: weight)
        return container
    }
    
    init(text: String = "", color: UIColor = .grayscales.label, size: CGFloat = 14, weight: UIFont.Weight = .regular) {
        self.color = color
        self.size = size
        self.weight = weight
        super.init(frame: .zero)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = color
        configuration.contentInsets = .init(top: 3, leading: 6, bottom: 3, trailing: 6)
        self.configuration = configuration
        
        defer {
            self.text = text
        }
        
        let darkGray: UIColor = .darkGray.withAlphaComponent(0.2)
        
        configurationUpdateHandler = { button in
            switch button.state {
            case [.selected, .highlighted]:
                button.configuration?.baseForegroundColor = .tintColors.blue
                button.configuration?.baseBackgroundColor = darkGray
            case .selected:
                button.configuration?.baseForegroundColor = .tintColors.blue
                button.configuration?.baseBackgroundColor = .clear
            case .highlighted:
                button.configuration?.baseBackgroundColor = darkGray
            case .normal:
                button.configuration?.baseForegroundColor = color
                button.configuration?.baseBackgroundColor = .clear
            default:
                button.configuration?.baseBackgroundColor = .clear
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showIndicator() {
        self.configuration?.showsActivityIndicator = true
    }
    
    func hideIndicator() {
        self.configuration?.showsActivityIndicator = false
    }

}
