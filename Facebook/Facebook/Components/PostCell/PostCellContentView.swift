//
//  PostCellself.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit

class PostCellself: UIView {

    
    // MARK: Setup
    
    private func initialSetup() {
        let commentLabel = commentCountLabel
        commentLabel.text = "43개"
        let likeLabel = likeCountLabel
        likeLabel.text = "4,234개"
    }
    
    func configure(with post: Post) {
        commentCountLabel.text = "댓글 \(Int.random(in: 10...100).withCommas(unit: "개"))"
        likeCountLabel.text = post.likes.withCommas(unit: "개")
        textContentLabel.text = post.content
        postHeader.configure(with: post)
    }
    
    // MARK: AutoLayout Constraints
    
    private func setLayout() {
        self.addSubview(postHeader)
        NSLayoutConstraint.activate([
            postHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            postHeader.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            postHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            postHeader.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        
        
        self.addSubview(textContentLabel)
        NSLayoutConstraint.activate([
            textContentLabel.topAnchor.constraint(equalTo: postHeader.bottomAnchor, constant: 10),
            textContentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            textContentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
        
        self.addSubview(statHorizontalStackView)
        NSLayoutConstraint.activate([
            statHorizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            statHorizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            statHorizontalStackView.topAnchor.constraint(equalTo: textContentLabel.bottomAnchor, constant: 10)
        ])
        
        self.addSubview(topBorder)
        NSLayoutConstraint.activate([
            topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            topBorder.heightAnchor.constraint(equalToConstant: 1),
            topBorder.topAnchor.constraint(equalTo: statHorizontalStackView.bottomAnchor, constant: 10)
        ])
        
        self.addSubview(buttonHorizontalStackView)
        NSLayoutConstraint.activate([
            buttonHorizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            buttonHorizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            buttonHorizontalStackView.topAnchor.constraint(equalTo: topBorder.bottomAnchor, constant: 5)
        ])
        
        self.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: buttonHorizontalStackView.bottomAnchor, constant: 5),
            divider.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 5),
        ])
    }
    
    // MARK: Initialize View Components
    
    let likeButton: UIButton = LikeButton()
    let commentButton: UIButton = CommentButton()
    let shareButton: UIButton = ShareButton()
    
    
    // 포스트 헤더 (프로필 이미지, 작성자, 날짜, 각종 버튼이 들어가는 곳)
    private lazy var postHeader = AuthorInfoHeaderView()
    
    // 좋아요, 댓글, 공유 버튼 나란히 있는 스택 뷰
    private lazy var buttonHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.addArrangedSubview(likeButton)
        stack.addArrangedSubview(commentButton)
//        stack.addArrangedSubview(shareButton)
        return stack
    }()
    
    // 좋아요 수, 댓글 수 등 각종 통계가 보이는 스택 뷰
    private lazy var statHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(likeCountLabelWithIcon)
        stack.addArrangedSubview(commentCountLabel)
        return stack
    }()
    
    // 좋아요 수 라벨
    private lazy var likeCountLabel: UILabel = InfoLabel()
    
    // 따봉 아이콘 + 좋아요 수
    private lazy var likeCountLabelWithIcon: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.addArrangedSubview(GradientIcon(width: 16))
        stack.addArrangedSubview(likeCountLabel)
        return stack
    }()
    
    // 댓글 수 라벨
    private lazy var commentCountLabel: UILabel = InfoLabel()
    
    // 버튼 스택 뷰 위에 보이는 디바이더
    private lazy var topBorder: UIView = {
        let divider = createHorizontalDivider()
        return divider
    }()
    
    // 본문 텍스트 라벨
    private lazy var textContentLabel: UILabel = {
        let textContentLabel = UILabel()
        textContentLabel.textColor = .black
        textContentLabel.numberOfLines = 3
        textContentLabel.font = .systemFont(ofSize: 16)
        textContentLabel.translatesAutoresizingMaskIntoConstraints = false
        return textContentLabel
    }()
    
    // 버튼 스택 뷰 아래 보이는 디바이더 (댓글이 있을때만 표시)
    private lazy var bottomBorder: UIView = {
        return createHorizontalDivider()
    }()
    
    // 피드와 피드 사이의 회색 리바이더
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .Grayscales.gray1
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    private func createHorizontalDivider() -> UIView {
        let line = UIView()
        line.backgroundColor = .Grayscales.gray2
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }

}
