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
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func configureCell(with subPost: Post) {
        textContentLabel.text = subPost.content
        setImage(from: URL(string: subPost.file ?? ""))
        
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
        
        contentView.addSubview(singleImageView)
        singleImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(contentView)
            make.height.equalTo(300)  // default estimated height
        }
        
        let divider = Divider()
        contentView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(singleImageView.snp.bottom)
            make.leading.trailing.bottom.equalTo(contentView)
            make.height.equalTo(5)
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
    }
    
    func setImage(from url: URL?) {
        guard let url = url else {
            return
        }
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 1000, height: 1000))
        KF.url(url)
          .setProcessor(processor)
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .fade(duration: 0.1)
          .onSuccess { result in
              print("height 업데이트")
              self.singleImageView.snp.updateConstraints { make in
                  make.height.equalTo(self.calcImageHeight(imageSize: result.image.size, viewWidth: self.frame.width))
              }
              
              var view = self.superview
              while (view != nil && (view as? UITableView) == nil) {
                view = view?.superview
              }
                      
              if let tableView = view as? UITableView {
                 tableView.beginUpdates()
                 tableView.endUpdates()
              }
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
