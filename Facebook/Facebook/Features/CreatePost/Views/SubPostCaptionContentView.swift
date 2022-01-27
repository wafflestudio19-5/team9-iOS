//
//  CreateSubPostContentView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/26.
//

import UIKit

class SubPostCaptionContentView: SubPostContentView {
    
    func configure(subpost: SubPost) {
        if let urlString = subpost.imageUrl {
            setImage(from: URL(string: urlString))
        } else if let image = subpost.prefetchedImage {
            setImage(from: image)
        }
    }
    
    func setImage(from image: UIImage?) {
        guard let image = image else { return }
        singleImageView.image = image
        singleImageView.snp.remakeConstraints { make in
            make.leading.trailing.top.equalTo(self)
            make.height.equalTo(self.calcImageHeight(imageSize: image.size, viewWidth: self.frame.width)).priority(.high)
        }
        layoutIfNeeded()
    }
    

    override func setLayout() {
        self.addSubview(singleImageView)
        singleImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self)
            make.height.equalTo(300)  // default estimated height
        }
        
        self.addSubview(captionTextView)
        captionTextView.snp.makeConstraints { make in
            make.top.equalTo(singleImageView.snp.bottom).offset(CGFloat.standardTopMargin)
            make.bottom.equalToSuperview().offset(CGFloat.standardBottomMargin)
            make.leading.trailing.equalTo(self).inset(CGFloat.standardLeadingMargin)
        }
    }
    
    lazy var captionTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.isScrollEnabled = false
        textView.placeholder = "설명 추가..."
        textView.font = .systemFont(ofSize: 15)
        return textView
    }()

}
