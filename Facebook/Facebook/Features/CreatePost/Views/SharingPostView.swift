//
//  SharingPostView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/22.
//

import UIKit

class SharingPostContentView: PostContentView {

    override func setLayout() {
        self.layer.borderColor = UIColor.grayscales.imageBorder.cgColor
        self.layer.borderWidth = 1
        
        self.addSubview(postHeader)
        postHeader.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(CGFloat.standardLeadingMargin - 3)
            make.trailing.equalTo(self).offset(CGFloat.standardTrailingMargin)
            make.top.equalTo(self).offset(CGFloat.standardTopMargin)
            make.height.equalTo(CGFloat.profileImageSize)
        }
        
        self.addSubview(textContentLabel)
        textContentLabel.snp.makeConstraints { make in
            make.top.equalTo(postHeader.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(self).inset(CGFloat.standardLeadingMargin)
        }
        
        let imageGridInset: CGFloat = 10
        imageGridCollectionView.maxWidth = self.frame.width - imageGridInset * 2
        self.addSubview(imageGridCollectionView)
        imageGridCollectionView.snp.makeConstraints { make in
            make.top.equalTo(textContentLabel.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.bottom.equalToSuperview().inset(imageGridInset)
        }
        
    }

}
