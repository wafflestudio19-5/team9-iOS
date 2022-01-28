//
//  PostDetailContentView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/25.
//

import UIKit

class PostDetailContentView: PostContentView {

    override func setLayout() {
        self.addSubview(textContentLabel)
        textContentLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.trailing.equalTo(self).inset(CGFloat.standardLeadingMargin)
        }
        
        self.addSubview(imageGridCollectionView)
        imageGridCollectionView.snp.makeConstraints { make in
            make.top.equalTo(textContentLabel.snp.bottom)
            make.leading.trailing.equalTo(self)
        }
        
        self.addSubview(sharedPostView)
        sharedPostView.isHidden = true
        sharedPostView.snp.remakeConstraints { make in
            make.top.equalTo(imageGridCollectionView.snp.bottom)
            make.leading.trailing.equalTo(0).inset(10)
            make.height.equalTo(0)
            make.bottom.equalTo(0)  // important
        }
    }
    
    override func configureSharedPost(with post: Post) {
        if post.is_sharing ?? false {
            sharedPostView.isHidden = false
            sharedPostView.configure(sharing: post.postSharing)  // recursive call!
            sharedPostView.snp.remakeConstraints { make in
                make.top.equalTo(imageGridCollectionView.snp.bottom).offset(CGFloat.standardTopMargin)
                make.leading.trailing.equalTo(0).inset(10)
                make.bottom.equalTo(0)  // important
            }
        } else {
            sharedPostView.isHidden = true
            sharedPostView.snp.remakeConstraints { make in
                make.top.equalTo(imageGridCollectionView.snp.bottom)
                make.leading.trailing.equalTo(0).inset(10)
                make.height.equalTo(0)
                make.bottom.equalTo(0)  // important
            }
        }
    }
    
    
}
