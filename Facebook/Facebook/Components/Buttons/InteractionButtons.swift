//
//  InteractionButton.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/17.
//

import UIKit
import SwiftUI

class InteractionButton: UIButton {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var symbolName: String { fatalError("Property symbolName is required.") }
    var textLabel: String { fatalError("Property textLabel is required.") }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setButtonStyle()
    }
    
    private func setButtonStyle() {
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .grayscales.label
        configuration.baseBackgroundColor = .clear
        configuration.image = UIImage(systemName: symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold))
        configuration.imagePadding = 5
        configuration.attributedTitle = AttributedString(textLabel, attributes: container)
        
        self.configuration = configuration
    }
}

class LikeButton: InteractionButton {
    override var textLabel: String { "좋아요" }
    override var symbolName: String { "hand.thumbsup" }
    var filledSymbolName: String {
        return "\(symbolName).fill"
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLikeButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLikeButtonStyle()
    }
    
    private func setLikeButtonStyle() {
        configurationUpdateHandler = { button in
            switch button.state {
            case [.selected, .highlighted]:
                button.configuration?.baseForegroundColor = FacebookColor.blue.color()
            case .selected:
                button.configuration?.image = UIImage(systemName: self.filledSymbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold))
                button.configuration?.baseForegroundColor = FacebookColor.blue.color()
            case .highlighted:
                button.configuration?.baseForegroundColor = .grayscales.label
            case .normal:
                button.configuration?.image = UIImage(systemName: self.symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold))
                button.configuration?.baseForegroundColor = .grayscales.label
            default:
                button.configuration?.baseForegroundColor = .grayscales.label
            }
        }
    }
    
    func toggleSelected() {
        self.isSelected = !isSelected
    }
}

class CommentButton: InteractionButton {
    override var textLabel: String { "댓글 달기" }
    override var symbolName: String { "bubble.right" }
}

class ShareButton: InteractionButton {
    override var textLabel: String { "공유하기" }
    override var symbolName: String { "arrowshape.turn.up.forward" }
}


