//
//  SubPostCell.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/11.
//

import UIKit
import Kingfisher

class SubPostCell: PostCell {
    
    override class var reuseIdentifier: String { "SubPostCell" }
    
    var singleImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func configureCell(with subPost: Post) {
        setImage(from: URL(string: subPost.file ?? ""))
        textContentLabel.text = subPost.content
        
//        singleImageView.snp.remakeConstraints { make in
//            make.top.leading.trailing.bottom.equalTo(contentView)
//            make.width.equalTo(contentView)
//            make.width.equalTo(contentView)
//
//        }
        print("configurecell")
//        print(self.frame)
    }


    override func setLayout() {
        contentView.backgroundColor = .blue
        contentView.autoresizingMask = [.flexibleHeight]
        
        contentView.addSubview(singleImageView)
        singleImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
//            make.width.equalTo(contentView)
            
        }
//        contentView.addSubview(textContentLabel)
//        textContentLabel.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalTo(contentView)
//        }

    }
    
    func setImage(from url: URL?) {
        guard let url = url else {
            return
        }
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 1000, height: 1000))
        
//        self.singleImageView.kf.setImage(
//            with: url,
//            placeholder: placeholderImage,
//            options: [
//                .processor(processor),
//                .loadDiskFileSynchronously,
//                .cacheOriginalImage,
//                .transition(.fade(0.25)),
//                .lowDataMode(.network(lowResolutionURL))
//            ],
//            progressBlock: { receivedSize, totalSize in
//                // Progress updated
//            },
//            completionHandler: { result in
//                // Done
//            }
//        )
//
        KF.url(url)
          .setProcessor(processor)
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .fade(duration: 0.1)
          .onSuccess { result in
              print("로딩 완료")
//              self.layoutIfNeeded()
//              self.singleImageView.invalidateIntrinsicContentSize()
              self.singleImageView.snp.remakeConstraints { make in
                  make.edges.equalTo(self.contentView)
                  make.width.equalTo(self.contentView)
                  make.height.equalTo(400)

              }
              self.layoutIfNeeded()
//              self.singleImageView.invalidateIntrinsicContentSize()
          }
          .onFailure { error in print("로딩 실패", error)}
          .set(to: self.singleImageView)
    }

}
