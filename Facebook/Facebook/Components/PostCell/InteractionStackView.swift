//
//  InteractionStackView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit

class InteractionStackView: UIStackView {
    
    /// 좋아요, 댓글, (공유) 버튼이 있는 Horizontal Stack 뷰
    
    let likeButton: UIButton = LikeButton()
    let commentButton: UIButton = CommentButton()
    
    // 버튼 스택 뷰 위에 보이는 디바이더
    private lazy var topBorder: UIView = {
        let line = UIView()
        line.backgroundColor = .Grayscales.gray2
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    private lazy var bottomBorder: UIView = {
        let line = UIView()
        line.backgroundColor = .Grayscales.gray2
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    init(useBottomBorder: Bool = false) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.distribution = .fillProportionally
        self.addArrangedSubview(likeButton)
        self.addArrangedSubview(commentButton)
        
        self.addSubview(topBorder)
        NSLayoutConstraint.activate([
            topBorder.heightAnchor.constraint(equalToConstant: 1),
            topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            topBorder.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        if useBottomBorder {
            self.addSubview(bottomBorder)
            NSLayoutConstraint.activate([
                bottomBorder.heightAnchor.constraint(equalToConstant: 1),
                bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
                bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
