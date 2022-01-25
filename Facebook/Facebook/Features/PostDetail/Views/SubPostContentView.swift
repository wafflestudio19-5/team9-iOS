//
//  SubPostContentView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/22.
//

import Foundation
import UIKit
import Kingfisher


class SubPostContentView: PostContentView {
    
    var singleImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    func configure(with subPost: Post) {
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
    
    override func setUpperLayout() {
        self.addSubview(singleImageView)
        singleImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self)
            make.height.equalTo(300)  // default estimated height
        }
        
        self.addSubview(textContentLabel)
        textContentLabel.snp.makeConstraints { make in
            make.top.equalTo(singleImageView.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(self).inset(CGFloat.standardLeadingMargin)
        }
        
        self.addSubview(statHorizontalStackView)
        statHorizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(textContentLabel.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(self).inset(CGFloat.standardLeadingMargin)
        }
    }
    
    func setImage(from url: URL?) {
        guard let url = url else {
            return
        }
        KF.url(url)
            .setProcessor(KFProcessors.shared.downsampling)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .onSuccess { result in
                self.singleImageView.snp.updateConstraints { make in
                    make.height.equalTo(self.calcImageHeight(imageSize: result.image.size, viewWidth: self.frame.width))
                }
                self.layoutIfNeeded()
            }
            .set(to: self.singleImageView)
    }
    
    func calcImageHeight(imageSize: CGSize, viewWidth: CGFloat) -> CGFloat {
        let myImageWidth = imageSize.width
        let myImageHeight = imageSize.height
        let ratio = viewWidth / myImageWidth
        return myImageHeight * ratio
    }
}
