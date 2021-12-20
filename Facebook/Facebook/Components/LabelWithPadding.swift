//
//  LabelWithPadding.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/13.
//

import UIKit

class LabelWithPadding: UILabel {
    
    private var padding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init(frame: CGRect.zero)
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += (padding.top + padding.bottom)
        contentSize.width += (padding.left + padding.right)
        
        return contentSize
    }
}
