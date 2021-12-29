//
//  InfoLabel.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit

class InfoLabel: UILabel {

    /// 좋아요 개수, 작성 시각 등 각종 정보를 표기하는 작은 회색 라벨
    
    init(color: UIColor = .darkGray, size: Int = 14, weight: UIFont.Weight = .regular) {
        super.init(frame: .zero)
        self.textColor = color
        self.font = .systemFont(ofSize: CGFloat(size), weight: weight)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
