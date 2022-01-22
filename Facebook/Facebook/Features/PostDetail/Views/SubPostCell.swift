//
//  SubPostCell.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/11.
//

import UIKit
import Kingfisher
import SnapKit

class SubPostCell: PostCell<SubPostContentView> {

    override class var reuseIdentifier: String { "SubPostCell" }
    
    override func configure(with newPost: Post, showGrid: Bool = false) {
        postContentView.configure(with: newPost)
    }
    
}
