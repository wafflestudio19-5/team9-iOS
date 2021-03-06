//
//  CommentCell.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/05.
//

import UIKit
import RxSwift
import RxGesture
import SwiftUI
import SnapKit

class CommentCell: UITableViewCell {
    
    static let reuseIdentifier = "CommentCell"
    
    var disposeBag = DisposeBag()
    private var leftMarginConstraint: NSLayoutConstraint?
    private var profileHeightConstraint: NSLayoutConstraint?
    private var profileWidthConstraint: NSLayoutConstraint?
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            likeCountLabel.text = comment.likes.withCommas()
            likeButton.isSelected = comment.is_liked
            likeCountLabelWithIcon.isHidden = comment.likes == 0
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CommentCell.reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        unfocus()
    }
    
    func like() {
        guard let oldComment = comment else { return }
        comment?.likes = oldComment.is_liked ? max(0, oldComment.likes - 1) : oldComment.likes + 1
        comment?.is_liked = !oldComment.is_liked
        if let isLiked = comment?.is_liked, isLiked {
            HapticManager.shared.impact(style: .light)
        }
    }
    
    func like(syncWith response: LikeResponse) {
        guard let comment = comment else { return }
        StateManager.of.comment.dispatch(comment, syncWith: response)
    }
    
    func configure(with comment: Comment) {
        self.comment = comment
        authorLabel.text = comment.author.username
        contentLabel.text = comment.content
        createdLabel.text = comment.posted_at
        
        profileImage.setImage(from: comment.author.profile_image)
        
        profileImage.snp.updateConstraints { make in
            make.height.width.equalTo(comment.profileImageSize)
            make.leading.equalTo(comment.leftMargin)
        }
    }
    
    private func setLayout() {
        contentView.addSubview(profileImage)
        contentView.addSubview(horizontalButtonStack)
        contentView.addSubview(bubbleView)
        contentView.addSubview(likeCountLabelWithIcon)
        
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(CGFloat.standardTopMargin)
            make.height.width.equalTo(40)
            make.leading.equalTo(10)
        }
        
        bubbleView.snp.makeConstraints { make in
            make.top.equalTo(CGFloat.standardTopMargin)
            make.leading.equalTo(profileImage.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualTo(CGFloat.standardTrailingMargin)
        }
        
        horizontalButtonStack.snp.makeConstraints { make in
            make.top.equalTo(bubbleView.snp.bottom).offset(4)
            make.leading.equalTo(bubbleView.snp.leading).offset(CGFloat.standardLeadingMargin)
            make.bottom.equalTo(0)
            make.height.equalTo(20)
        }
        
        likeCountLabelWithIcon.snp.makeConstraints { make in
            make.centerY.equalTo(horizontalButtonStack).offset(-2)
            make.trailing.equalTo(contentView).offset(CGFloat.standardTrailingMargin)
            //            make.height.equalTo(horizontalButtonStack)
        }
    }
    
    // MARK: Public Functions
    
    func focus() {
        UIView.animate(withDuration: 0.5) {
            self.bubbleView.backgroundColor = .grayscales.bubbleFocused
        }
    }
    
    func unfocus() {
        UIView.animate(withDuration: 0.5) {
            self.bubbleView.backgroundColor = .grayscales.bubble
        }
    }
    
    // MARK: UI Components
    
    private lazy var horizontalButtonStack: UIStackView = {
        let horizontalStackForButtons = UIStackView()
        horizontalStackForButtons.axis = .horizontal
        horizontalStackForButtons.alignment = .center
        horizontalStackForButtons.addArrangedSubview(createdLabel)
        horizontalStackForButtons.addArrangedSubview(likeButton)
        horizontalStackForButtons.addArrangedSubview(replyButton)
        horizontalStackForButtons.setCustomSpacing(8, after: createdLabel)
        horizontalStackForButtons.setCustomSpacing(2, after: likeButton)
        return horizontalStackForButtons
    }()
    
    lazy var bubbleView: UIView = {
        let bubbleView = UIView()
        bubbleView.addSubview(authorLabel)
        bubbleView.addSubview(contentLabel)
        bubbleView.backgroundColor = .grayscales.bubble
        bubbleView.layer.cornerRadius = 18
        authorLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(bubbleView).offset(6)
            make.trailing.lessThanOrEqualTo(bubbleView).offset(-6)
            make.height.equalTo(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom)
            make.trailing.equalTo(-12)
            make.leading.equalTo(12)
            make.bottom.equalTo(-6)
        }
        return bubbleView
    }()
    
    let profileImage = ProfileImageView()
    let authorLabel: InfoButton = {
        let button = InfoButton(color: .label, size: 13, weight: .semibold)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
        
    }()
    
    let contentLabel: UILabel = {
        let label = InfoLabel(color: .label, size: 16, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    
    private var createdLabel = InfoLabel(size: 13)
    
    // 좋아요 수 라벨
    private let likeCountLabel: UILabel = InfoLabel(size: 13, weight: .medium)
    
    // 따봉 아이콘 + 좋아요 수
    private lazy var likeCountLabelWithIcon: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.alignment = .center
        likeCountLabel.text = 5.withCommas()
        stack.addArrangedSubview(likeCountLabel)
        stack.addArrangedSubview(GradientIcon(width: .gradientIconWidth))
        return stack
    }()
    
    var likeButton = InfoButton(text: "좋아요", size: 13, weight: .semibold)
    
    var replyButton = InfoButton(text: "답글 달기", size: 13, weight: .semibold)
    
    // MARK: UI for Edit
    
    var bubbleTextView: FlexibleTextView = {
        let textView = FlexibleTextView()
        textView.font = .systemFont(ofSize: 15)
        textView.maxHeight = 140
        textView.layer.cornerRadius = 18
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.grayscales.border.cgColor
        textView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        return textView
    }()
    
    var updateButton: InfoButton = {
        let button = InfoButton(text: "업데이트", color: .white, size: 14)
        button.configurationUpdateHandler = nil
        button.configuration?.baseBackgroundColor = .tintColors.blue
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = InfoButton(text: "취소", size: 14)
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.grayscales.border.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 6
        return button
    }()
}

// MARK: Prepare UI For Editing

extension CommentCell {
    func startEditing() {
        bubbleView.isHidden = true
        horizontalButtonStack.isHidden = true
        likeCountLabelWithIcon.isHidden = true
        bubbleTextView.text = contentLabel.text
        bubbleTextView.becomeFirstResponder()
        contentView.addSubview(bubbleTextView)
        contentView.addSubview(updateButton)
        contentView.addSubview(cancelButton)
        bubbleTextView.snp.remakeConstraints { make in
            make.top.equalTo(CGFloat.standardTopMargin)
            make.leading.equalTo(profileImage.snp.trailing).offset(4)
            make.trailing.equalTo(CGFloat.standardTrailingMargin)
            make.height.equalTo(140).priority(.high)
        }
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(bubbleTextView.snp.bottom).offset(10)
            make.trailing.equalTo(bubbleTextView)
            make.bottom.equalTo(0)
            make.height.equalTo(25)
        }
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(updateButton)
            make.trailing.equalTo(updateButton.snp.leading).offset(-10)
            make.height.equalTo(25)
        }
        
    }
    
    private func finishEditing() {
        bubbleView.isHidden = false
        horizontalButtonStack.isHidden = false
        likeCountLabelWithIcon.isHidden = comment?.likes == 0
        bubbleTextView.removeFromSuperview()
        updateButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
    }
    
    func cancelEditing() {
        finishEditing()
    }
    
    func completeEditing() {
        contentLabel.text = bubbleTextView.text
        finishEditing()
    }
    
}

// MARK: SwiftUI Preview

struct CommentCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = CommentCell().contentView
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct CommentCellPreview: PreviewProvider {
    static var previews: some View {
        VStack{
            Spacer()
            CommentCellRepresentable()
            Spacer()
        }.preferredColorScheme(.light).previewDevice("iPhone 12 Pro").background(.white)
    }
}
