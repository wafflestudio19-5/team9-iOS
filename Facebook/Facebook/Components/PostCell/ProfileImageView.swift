//
//  ProfileImageView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit

class ProfileImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let config = UIImage.SymbolConfiguration(hierarchicalColor: .systemFill)
        self.image = UIImage(systemName: "person.crop.circle.fill", withConfiguration: config)
        self.contentMode = .scaleAspectFit
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
}
