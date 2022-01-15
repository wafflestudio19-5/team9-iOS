//
//  FriendGridCollectionCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/15.
//

import UIKit

class FriendGridCollectionView: ContentSizeFitCollectionView {
    let spacing: CGFloat = 10
    
    init(frame: CGRect = .zero) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(FriendGridCell.self, forCellWithReuseIdentifier: FriendGridCell.reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isScrollEnabled = false
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FriendGridCollectionView: UICollectionViewDelegateFlowLayout {
    private func getItemSize() -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth: CGFloat = (screenWidth - 50) / 3
        let itemHeight: CGFloat = itemWidth + 40
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getItemSize()
    }
    
}
