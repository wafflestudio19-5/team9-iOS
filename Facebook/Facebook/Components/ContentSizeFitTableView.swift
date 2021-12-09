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
