//
//  SharedPostContentView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/23.
//

import UIKit

class SharedPostContentView: PostContentView {

    override func setLayout() {
        let borderView = UIView()
        borderView.layer.borderColor = UIColor.grayscales.imageBorder.cgColor
        borderView.layer.borderWidth = 1
        self.addSubview(borderView)
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
        imageGridCollectionView.maxWidth = self.frame.width
        self.addSubview(imageGridCollectionView)
        imageGridCollectionView.snp.makeConstraints { make in
            make.top.equalTo(textContentLabel.snp.bottom).offset(CGFloat.standardTopMargin)
            make.bottom.equalToSuperview().inset(imageGridInset).priority(.high)
            make.leading.trailing.equalToSuperview().inset(-imageGridInset).priority(.high)
        }
        
    }

}
