//
//  ProfileInfoHeaderView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit
import SwiftUI

class AuthorInfoHeaderView: UIView {

    /// 피드 상단, 게시자의 프로필 이미지와 닉네임, 작성 시각 등이 표시되는 뷰
    
    init(imageWidth: CGFloat = .profileImageSize) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.text = "일론 머스크"  // preview 용도
        postDateLabel.text = "17시간 전"
        
        self.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -3),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            profileImageView.heightAnchor.constraint(equalToConstant: imageWidth)
        ])
        
        let labelStack = UIView()
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.addSubview(authorNameLabel)
        labelStack.addSubview(postDateLabel)
        NSLayoutConstraint.activate([
            authorNameLabel.topAnchor.constraint(equalTo: labelStack.topAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: labelStack.leadingAnchor),
            postDateLabel.leadingAnchor.constraint(equalTo: labelStack.leadingAnchor),
            postDateLabel.bottomAnchor.constraint(equalTo: labelStack.bottomAnchor),
            postDateLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor)
        ])
        
        self.addSubview(labelStack)
        NSLayoutConstraint.activate([
            labelStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            labelStack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5)
        ])
    }
    
    func configure(with post: Post) {
        authorNameLabel.text = post.author.username
        postDateLabel.text = post.posted_at
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Profile Image가 표시되는 뷰 (현재는 아이콘으로 구현)
    private lazy var profileImageView = ProfileImageView()
    
    // 작성자 이름 라벨
    private lazy var authorNameLabel: UILabel = InfoLabel(color: .black, size: 16, weight: .medium)
    
    // 작성 시간 라벨
    private lazy var postDateLabel: UILabel = InfoLabel()
}


struct AuthorInfoHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let authorInfoHeaderView = AuthorInfoHeaderView()
        SwiftUIRepresentable(view: authorInfoHeaderView)
    }
}
