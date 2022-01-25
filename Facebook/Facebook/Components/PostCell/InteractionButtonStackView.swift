//
//  InteractionStackView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit
import SwiftUI

class InteractionButtonStackView: UIStackView {
    
    /// 좋아요, 댓글, (공유) 버튼이 있는 Horizontal Stack 뷰
    
    let likeButton = LikeButton()
    let commentButton = CommentButton()
    let shareButton = ShareButton()
    
    // 버튼 스택 뷰 위아래에 보이는 디바이더
    private let topBorder: UIView = Divider()
    private let bottomBorder: UIView = Divider()
    
    init(useBottomBorder: Bool = false) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.distribution = .fillProportionally
        self.addArrangedSubview(likeButton)
        self.addArrangedSubview(commentButton)
        self.addArrangedSubview(shareButton)
        
        self.addSubview(topBorder)
        topBorder.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.top.equalToSuperview()
        }
        
        if useBottomBorder {
            self.addSubview(bottomBorder)
            bottomBorder.snp.remakeConstraints { make in
                make.height.equalTo(1)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
