//
//  ImageGridCollectionView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/30.
//

import UIKit

class ImageGridCollectionView: ContentSizeFitCollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(ImageGridCell.self, forCellWithReuseIdentifier: ImageGridCell.reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .blue
        self.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
