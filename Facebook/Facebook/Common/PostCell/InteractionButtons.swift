//
//  InteractionButton.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/17.
//

import UIKit
import SwiftUI

class LikeButton: UIButton {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var symbolName: String { "hand.thumbsup" }
    var textLabel: String { "좋아요" }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setButtonStyle()
    }
    
    func setButtonStyle() {
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .darkGray
        configuration.image = UIImage(systemName: symbolName, withConfiguration: iconConfig)?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        configuration.imagePadding = 5
        configuration.attributedTitle = AttributedString(textLabel, attributes: container)
        self.configuration = configuration
    }
}

class CommentButton: LikeButton {
    override var textLabel: String { "댓글 달기" }
    override var symbolName: String { "bubble.right" }
}

class ShareButton: LikeButton {
    override var textLabel: String { "공유하기" }
    override var symbolName: String { "arrowshape.turn.up.forward" }
}


