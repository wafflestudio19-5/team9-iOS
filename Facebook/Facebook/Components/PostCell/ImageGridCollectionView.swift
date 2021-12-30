//
//  ImageGridCollectionView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/30.
//

import UIKit

class ImageGridCollectionView: ContentSizeFitCollectionView {
    var numberOfImages: Int = 0 {
        willSet(newValue) {
            if newValue == 0 {
                self.isHidden = true
            } else {
                self.isHidden = false
            }
        }
    }
    let spacing: CGFloat = 5
    let eps: CGFloat = 0.000001
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(ImageGridCell.self, forCellWithReuseIdentifier: ImageGridCell.reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isScrollEnabled = false
        self.delegate = self
        self.backgroundColor = .blue
        self.isHidden = true  // hide by default
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 자기 자신 View의 레이아웃과 관련 있는 로직이므로, 재사용성을 높이기 위해 Delegate를 자기 자신으로 설정한다.
extension ImageGridCollectionView: UICollectionViewDelegateFlowLayout {
    
    enum FractionalLength {
        case one
        case oneHalf
        case oneThird
        case twoThirds
        case threeFourths
        
        var fractionalValue: CGFloat {
            switch self {
            case .one: return 1
            case .oneHalf: return 1 / 2.0
            case .oneThird: return 1 / 3.0
            case .twoThirds: return 2 / 3.0
            case .threeFourths: return 3 / 4.0
            }
        }
    }
    
    private func getItemSize(width: FractionalLength, height: FractionalLength) -> CGSize {
        let screenWidth = self.bounds.size.width
        let itemWidth: CGFloat = (screenWidth - spacing * (1 / width.fractionalValue - 1)) * width.fractionalValue
        let itemHeight: CGFloat = screenWidth * height.fractionalValue
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = indexPath.item
        
        switch numberOfImages {
        case 1:
            return getItemSize(width: .one, height: .threeFourths)
        case 2:
            return getItemSize(width: .oneHalf, height: .threeFourths)
        case 3:
            if item < 1 {
                return getItemSize(width: .one, height: .oneHalf)
            } else {
                return getItemSize(width: .oneHalf, height: .oneHalf)
            }
        case 4:
            return getItemSize(width: .oneHalf, height: .oneHalf)
        default:
            if item < 2 {
                return getItemSize(width: .oneHalf, height: .oneHalf)
            } else {
                return getItemSize(width: .oneThird, height: .oneThird)
            }
        }
    }
}
