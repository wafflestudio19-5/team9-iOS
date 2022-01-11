//
//  ContentSizeFitTableView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import UIKit

class ContentSizeFitTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class ContentSizeFitCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height == 0 ? 1 : contentSize.height)  // height가 0인 상태에서는 셀이 추가되지 않는 버그가 있음.
    }
}


class ContentSizeFitImageView: UIImageView {
    override var image: UIImage? {
        didSet {
            print("imageDidset")
          invalidateIntrinsicContentSize()
        }
      }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
//            print("myVIewWIdth", myViewWidth, scaledHeight)
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: 1)
    }
}
