//
//  PostCell.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/18.
//

import UIKit
import SwiftUI
import RxSwift

class PostCell: UITableViewCell {
    var disposeBag = DisposeBag()
    static let reuseIdentifier = "PostCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        initialSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
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
    
    private func initialSetup() {
        let commentLabel = commentCountLabel
        commentLabel.text = "43개"
        let likeLabel = likeCountLabel
        likeLabel.text = "4,234개"
    }
    
    func configureCell(with post: Post) {
        commentCountLabel.text = "댓글 \(Int.random(in: 10...100).withCommas(unit: "개"))"
        likeCountLabel.text = post.likes.withCommas(unit: "개")
        textContentLabel.text = post.content
        postHeader.configure(with: post)
    }
    
    // MARK: AutoLayout Constraints
    
    private func setLayout() {
        contentView.addSubview(postHeader)
        NSLayoutConstraint.activate([
            postHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .standardLeadingMargin),
            postHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .standardTrailingMargin),
            postHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .standardTopMargin),
            postHeader.heightAnchor.constraint(equalToConstant: .profileImageSize),
        ])
        
        contentView.addSubview(textContentLabel)
        NSLayoutConstraint.activate([
            textContentLabel.topAnchor.constraint(equalTo: postHeader.bottomAnchor, constant: .standardTopMargin),
            textContentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .standardLeadingMargin),
            textContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .standardTrailingMargin),
        ])
        
        contentView.addSubview(statHorizontalStackView)
        NSLayoutConstraint.activate([
            statHorizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .standardLeadingMargin),
            statHorizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .standardTrailingMargin - 5),
            statHorizontalStackView.topAnchor.constraint(equalTo: textContentLabel.bottomAnchor, constant: .standardTopMargin)
        ])
        
        contentView.addSubview(buttonHorizontalStackView)
        contentView.addSubview(divider)
        NSLayoutConstraint.activate([
            buttonHorizontalStackView.topAnchor.constraint(equalTo: statHorizontalStackView.bottomAnchor, constant: .standardTopMargin),
            buttonHorizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .standardLeadingMargin),
            buttonHorizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .standardTrailingMargin),
            buttonHorizontalStackView.heightAnchor.constraint(equalToConstant: .buttonGroupHeight)
        ])
        
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: buttonHorizontalStackView.bottomAnchor),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 5),
        ])
    }
    
    // MARK: Initialize View Components
    
    // 포스트 헤더 (프로필 이미지, 작성자, 날짜, 각종 버튼이 들어가는 곳)
    private lazy var postHeader = AuthorInfoHeaderView()
    
    // 좋아요, 댓글, 공유 버튼 나란히 있는 스택 뷰
    lazy var buttonHorizontalStackView = InteractionStackView()
    
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
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.addArrangedSubview(GradientIcon(width: .gradientIconWidth))
        stack.addArrangedSubview(likeCountLabel)
        return stack
    }()
    
    // 댓글 수 라벨
    private lazy var commentCountLabel: UILabel = InfoLabel()
    
    // 본문 텍스트 라벨
    private lazy var textContentLabel = PostContentLabel()
    
    // 피드와 피드 사이의 회색 리바이더
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .Grayscales.gray1
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
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
