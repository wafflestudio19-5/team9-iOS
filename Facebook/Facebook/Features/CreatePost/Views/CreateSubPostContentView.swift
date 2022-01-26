//
//  CreateSubPostContentView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/26.
//

import UIKit

class CreateSubPostContentView: SubPostContentView {
    
    override func configure(with subPost: Post) {
        self.post = subPost
        textContentLabel.text = subPost.content
        setImage(from: URL(string: subPost.file ?? ""))
        let isEmptyContent = subPost.content.isEmpty
        textContentLabel.isHidden = isEmptyContent
        statHorizontalStackView.snp.remakeConstraints { make in
            make.top.equalTo(isEmptyContent ? singleImageView.snp.bottom : textContentLabel.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(self).inset(CGFloat.standardLeadingMargin)
        }
    }

    override func setLayout() {
        self.addSubview(singleImageView)
        singleImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self)
            make.height.equalTo(300)  // default estimated height
        }
        
        self.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(CGFloat.standardTopMargin)
            make.bottom.equalToSuperview().offset(CGFloat.standardBottomMargin)
            make.leading.trailing.equalTo(self).inset(CGFloat.standardLeadingMargin)
        }
    }
    
    var textView = FlexibleTextView()

}
