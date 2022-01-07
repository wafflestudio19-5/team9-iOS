//
//  PostContentLabel.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit

class PostContentLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init() {
        super.init(frame: .zero)
        self.textColor = .label
        self.numberOfLines = 0
        self.font = .systemFont(ofSize: 16)
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
