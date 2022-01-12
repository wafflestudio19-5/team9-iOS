//
//  SubPostCell.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/11.
//

import UIKit
import Kingfisher
import SnapKit

class SubPostCell: PostCell {
    
    override class var reuseIdentifier: String { "SubPostCell" }
    
    var singleImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func configureCell(with subPost: Post) {
        self.post = subPost
        textContentLabel.text = subPost.content
        setImage(from: URL(string: subPost.file ?? ""))
    }
    
    override func setLayout() {
        contentView.addSubview(singleImageView)
        singleImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(contentView)
            make.height.equalTo(300)  // default estimated height
        }
        
        contentView.addSubview(textContentLabel)
        textContentLabel.snp.makeConstraints { make in
            make.top.equalTo(singleImageView.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(contentView).inset(CGFloat.standardLeadingMargin)
        }
        
        contentView.addSubview(statHorizontalStackView)
        statHorizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(textContentLabel.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(contentView).inset(CGFloat.standardLeadingMargin)
        }
        
        contentView.addSubview(buttonHorizontalStackView)
        buttonHorizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(statHorizontalStackView.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(contentView).inset(CGFloat.standardLeadingMargin)
            make.height.equalTo(CGFloat.buttonGroupHeight)
        }
        
        contentView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(buttonHorizontalStackView.snp.bottom)
            make.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView).priority(.high)
            make.height.equalTo(5)
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
            .onFailure { error in print("로딩 실패", error)}
            .set(to: self.singleImageView)
    }
    
    func calcImageHeight(imageSize: CGSize, viewWidth: CGFloat) -> CGFloat {
        let myImageWidth = imageSize.width
        let myImageHeight = imageSize.height
        let ratio = viewWidth / myImageWidth
        return myImageHeight * ratio
    }
}
