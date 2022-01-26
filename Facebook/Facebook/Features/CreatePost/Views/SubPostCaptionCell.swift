//
//  SubPostCaptionCell.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/27.
//

import UIKit
import SnapKit

class SubPostCaptionCell: PostCell<SubPostCaptionContentView> {

    override class var reuseIdentifier: String { "SubPostCaptionCell" }
    
    override func configure(with newPost: Post, showGrid: Bool = false) {
        fatalError("Not Implemented.")
    }
    
    func configure(subpost: SubPost) {
        postContentView.configure(subpost: subpost)
    }
    
}
