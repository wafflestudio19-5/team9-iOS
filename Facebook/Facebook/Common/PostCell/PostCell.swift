//
//  PostCell.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/18.
//

import UIKit
import SwiftUI

class PostCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("Do not use storyboard. Load programmatically.")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: Setup
    
    // MARK: Dummy Fields
    
    private func initialSetup() {
        let commentLabel = commentCountLabel
        commentLabel.text = "43개"
        let likeLabel = likeCountLabel
        likeLabel.text = "4,234개"
    }
    
    func configureCell(with post: Post) {
        commentCountLabel.text = "댓글 \(Int.random(in: 10...100).withCommas(unit: "개"))"
        likeCountLabel.text = post.likes.withCommas(unit: "개")
        authorNameLabel.text = post.author.username
        postDateLabel.text = post.posted_at
        textContentLabel.text = post.content
    }
    
    // MARK: AutoLayout Constraints
    
    private func setLayout() {
        contentView.addSubview(postHeader)
        NSLayoutConstraint.activate([
            postHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            postHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            postHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            postHeader.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        postHeader.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: postHeader.leadingAnchor, constant: -3),
            profileImageView.topAnchor.constraint(equalTo: postHeader.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: postHeader.bottomAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        postHeader.addSubview(authorNameLabel)
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5),
            authorNameLabel.topAnchor.constraint(equalTo: postHeader.topAnchor, constant: 7)
        ])
        
        postHeader.addSubview(postDateLabel)
        NSLayoutConstraint.activate([
            postDateLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            postDateLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor),
        ])
        
        contentView.addSubview(statHorizontalStackView)
        NSLayoutConstraint.activate([
            statHorizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            statHorizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statHorizontalStackView.topAnchor.constraint(equalTo: textContentLabel.bottomAnchor, constant: 10)
        ])
        
        contentView.addSubview(topBorder)
        NSLayoutConstraint.activate([
            topBorder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            topBorder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            topBorder.heightAnchor.constraint(equalToConstant: 1),
            topBorder.topAnchor.constraint(equalTo: statHorizontalStackView.bottomAnchor, constant: 10)
        ])
        
        contentView.addSubview(buttonHorizontalStackView)
        NSLayoutConstraint.activate([
            buttonHorizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            buttonHorizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            buttonHorizontalStackView.topAnchor.constraint(equalTo: topBorder.bottomAnchor, constant: 5)
        ])
        
        contentView.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: buttonHorizontalStackView.bottomAnchor, constant: 5),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 5),
        ])
    }
    
    // MARK: Initialize View Components
    
    let likeButton: UIButton = LikeButton()
    let commentButton: UIButton = CommentButton()
    let shareButton: UIButton = ShareButton()
    
    // Profile Image
    private lazy var profileImageView: UIImageView = {
        let image = UIImage(systemName: "person.crop.circle")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var postDateLabel: UILabel = {
        let label = createStatLabel()
        return label
    }()
    
    // 포스트 헤더 (프로필 이미지, 작성자, 날짜, 각종 버튼이 들어가는 곳)
    private lazy var postHeader: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    
    // 좋아요, 댓글, 공유 버튼 나란히 있는 스택 뷰
    private lazy var buttonHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.addArrangedSubview(likeButton)
        stack.addArrangedSubview(commentButton)
        stack.addArrangedSubview(shareButton)
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
    private lazy var likeCountLabel: UILabel = {
        return createStatLabel()
    }()
    
    // 따봉 아이콘 + 좋아요 수
    private lazy var likeCountLabelWithIcon: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.addArrangedSubview(GradientIcon(width: 16))
        stack.addArrangedSubview(likeCountLabel)
        return stack
    }()
    
    // 댓글 수 라벨
    private lazy var commentCountLabel: UILabel = {
        return createStatLabel()
    }()
    
    // 버튼 스택 뷰 위에 보이는 디바이더
    private lazy var topBorder: UIView = {
        let divider = createHorizontalDivider()
        return divider
    }()
    
    private lazy var textContentLabel: UILabel = {
        let textContentLabel = UILabel()
        textContentLabel.text = "테스트 테스트 테스트 이에요. 테스트 테스트 테스트이에요.테스트 테스트 테스트 이에요.테스트 테스트 테스트 이에요.테스트 테스트 테스트 이에요.테스트 테스트 테스트 이에요."
        textContentLabel.textColor = .black
        textContentLabel.numberOfLines = 3
        textContentLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(textContentLabel)
        textContentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textContentLabel.topAnchor.constraint(equalTo: postHeader.bottomAnchor, constant: 10),
            textContentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
        return textContentLabel
    }()
    
    // 버튼 스택 뷰 아래 보이는 디바이더 (댓글이 있을때만 표시)
    private lazy var bottomBorder: UIView = {
        return createHorizontalDivider()
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 211/255.0, green: 214/255.0, blue: 216/255.0, alpha: 1)
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    private func createHorizontalDivider() -> UIView {
        let line = UIView()
        line.backgroundColor = .gray.withAlphaComponent(0.2)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }
    
    private func createStatLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

/*
 MARK: SwiftUI Preview
 */

struct PostCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = PostCell().contentView
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct PostCellPreview: PreviewProvider {
    static var previews: some View {
        VStack{
            Spacer()
            PostCellRepresentable()
            Spacer()
        }.background(.white)
    }
}
