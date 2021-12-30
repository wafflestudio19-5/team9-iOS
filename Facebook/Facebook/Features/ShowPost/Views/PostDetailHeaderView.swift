//
//  PostContentHeaderView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit

class PostDetailHeaderView: UIView {
    
    /// 포스팅 상세페이지 상단의 게시글 뷰. 댓글 TableView의 헤더로 들어간다.
    
    private let contentLabel = PostContentLabel()
    let buttonStackView = InteractionButtonStackView(useBottomBorder: true)
    private let authorHeaderView = AuthorInfoHeaderView()
    
    // 좋아요 수 라벨
    private let likeCountLabel: UILabel = InfoLabel(color: .black, weight: .semibold)
    
    // 따봉 아이콘 + 좋아요 수
    private lazy var likeCountLabelWithIcon: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.addArrangedSubview(GradientIcon(width: .gradientIconWidth))
        stack.addArrangedSubview(likeCountLabel)
        return stack
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .Grayscales.gray2
        return divider
    }()
    
    func configure(with post: Post) {
        contentLabel.text = post.content
        likeCountLabel.text = post.likes.withCommas(unit: "개")
        authorHeaderView.configure(with: post)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        self.addSubview(contentLabel)
        var trailing = contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .standardTrailingMargin)
        trailing.priority = .defaultHigh
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: .standardTopMargin + 5),
            contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            trailing,
        ])
        
        self.addSubview(buttonStackView)
        trailing = buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .standardTrailingMargin)
        trailing.priority = .defaultHigh
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: .standardTopMargin),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            trailing,
            buttonStackView.heightAnchor.constraint(equalToConstant: .buttonGroupHeight),
        ])
        
        self.addSubview(likeCountLabelWithIcon)
        NSLayoutConstraint.activate([
            likeCountLabelWithIcon.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: .standardTopMargin),
            likeCountLabelWithIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            likeCountLabelWithIcon.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        self.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: likeCountLabelWithIcon.bottomAnchor, constant: .standardTopMargin),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    

}
