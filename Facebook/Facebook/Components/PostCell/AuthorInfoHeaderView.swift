//
//  ProfileInfoHeaderView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit

class AuthorInfoHeaderView: UIView {

    /// 피드 상단, 게시자의 프로필 이미지와 닉네임, 작성 시각 등이 표시되는 뷰
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -3),
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: .profileImageSize)
        ])
        
        self.addSubview(authorNameLabel)
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5),
            authorNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7)
        ])
        
        self.addSubview(postDateLabel)
        NSLayoutConstraint.activate([
            postDateLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            postDateLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor),
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
