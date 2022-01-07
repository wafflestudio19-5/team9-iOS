//
//  PostView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/05.
//

import UIKit

class PostDetailView: UIView {
    
    let commentTableView = ResponsiveTableView()
    let postContentHeaderView = PostDetailHeaderView()
    
    var likeButton: LikeButton {
        postContentHeaderView.buttonStackView.likeButton
    }
    
    var commentButton: CommentButton {
        postContentHeaderView.buttonStackView.commentButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        self.addSubview(commentTableView)
        commentTableView.tableHeaderView = postContentHeaderView
        commentTableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        commentTableView.allowsSelection = false
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.delaysContentTouches = false
        commentTableView.keyboardDismissMode = .interactive
        commentTableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: self.topAnchor),
            commentTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            commentTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            postContentHeaderView.widthAnchor.constraint(equalTo: commentTableView.widthAnchor)
        ])
    }
    
    // MARK: Keyboard Accessory Components
    
    lazy var textView: FlexibleTextView = {
        let textView = FlexibleTextView()
        textView.placeholder = "댓글을 입력하세요..."
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .grayscales.bubble
        textView.maxHeight = 80
        textView.layer.cornerRadius = 17
        textView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        return textView
    }()
    
    
    var focusedAuthorLabel = InfoLabel(size: 12, weight: .semibold)
    var cancelFocusingButton = InfoLabel(size: 12, weight: .regular)
    
    /// "~에게 답글 남기는 중 ·" 부분
    lazy var focusedCommentInfo: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.isHidden = true
        
        let trailingLabel = InfoLabel(size: 12, weight: .regular)
        trailingLabel.text = "님에게 답글 남기는 중 · "
        cancelFocusingButton.text = "취소"
        
        stackview.addArrangedSubview(focusedAuthorLabel)
        stackview.addArrangedSubview(trailingLabel)
        stackview.addArrangedSubview(cancelFocusingButton)
        
        return stackview
    }()
    
    var sendButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "paperplane.fill")
        config.baseForegroundColor = FacebookColor.blue.color()
        
        let button = UIButton()
        button.configuration = config
        button.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        return button
    }()
    
    let photosButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "photo.on.rectangle.angled")
        config.cornerStyle = .capsule
        
        let button = UIButton()
        button.configuration = config
        return button
    }()
    
    let divider = Divider()
    
    lazy var keyboardAccessory: UIView = {
        let customInputView = CustomInputAccessoryView()
        customInputView.addSubview(textView)
        customInputView.addSubview(sendButton)
        customInputView.addSubview(divider)
        customInputView.addSubview(focusedCommentInfo)
        
        textView.snp.makeConstraints { make in
            make.leading.equalTo(CGFloat.standardLeadingMargin)
            make.bottom.equalTo(customInputView.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.trailing.equalTo(sendButton.snp.leading)
            make.top.equalTo(focusedCommentInfo.snp.bottom)
            make.height.greaterThanOrEqualTo(34)
        }
        
        sendButton.snp.makeConstraints { make in
            make.leading.equalTo(textView.snp.trailing)
            make.trailing.equalTo(-8)
            make.bottom.equalTo(customInputView.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.leading.trailing.equalTo(0)
        }
        
        focusedCommentInfo.snp.makeConstraints { make in
            make.height.equalTo(0)  // update to 20 when expanded
            make.leading.equalTo(textView.snp.leading).offset(CGFloat.standardLeadingMargin)
            make.top.equalTo(8)
        }
        
        
        return customInputView
    }()
    
    func showFocusedInfo(with authorName: String) {
        focusedAuthorLabel.text = authorName
        focusedCommentInfo.isHidden = false
        focusedCommentInfo.snp.remakeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalTo(textView.snp.leading).offset(CGFloat.standardLeadingMargin)
            make.top.equalTo(2)
        }
    }
    
    func hideFocusedInfo() {
        focusedAuthorLabel.text = ""
        focusedCommentInfo.isHidden = true
        focusedCommentInfo.snp.remakeConstraints { make in
            make.height.equalTo(0)  // update to 20 when expanded
            make.leading.equalTo(textView.snp.leading).offset(CGFloat.standardLeadingMargin)
            make.top.equalTo(8)
        }
    }
}
