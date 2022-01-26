//
//  NotificationCell.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/17.
//

import UIKit
import RxSwift

class NotificationCell: UITableViewCell {
    
    static let reuseIdentifier = "NotificationCell"
    
    var disposeBag = DisposeBag()

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.numberOfLines = 3
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    lazy var subcontentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var timeStampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var profileImage = ProfileImageView()
    
    lazy var verticalStackForContents: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3.0
        stackView.alignment = .leading
        return stackView
    }()
    
    lazy var horizontalStackForSubcontents: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3.0
        stackView.alignment = .leading
        return stackView
    }()
    
    lazy var detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    /// 확인 버튼: 친구 요청과 관련된 알림일 때에만 사용하는 버튼입니다.
    lazy var acceptButton: UIButton = {
        let button = RectangularSlimButton(title: "확인", titleColor: .white, backgroundColor: .tintColors.blue, height: 32.0, titleSize: 14.0)
    
        return button
    }()
    
    /// 삭제 버튼: 친구 요청과 관련된 알림일 때에만 사용하는 버튼입니다.
    lazy var deleteButton: UIButton = {
        let button = RectangularSlimButton(title: "삭제", titleColor: .black, backgroundColor: .grayscales.button, height: 32.0, titleSize: 14.0)
    
        return button
    }()
    
    /// 버튼 스택: 확인 버튼과 삭제 버튼을 담고 있는 스택으로, 친구 요청과 관련된 알림일 때에만 사용됩니다.
    lazy var horizontalStackForButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(acceptButton)
        stackView.addArrangedSubview(deleteButton)
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.tintColor = .black
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
        removeButtonForFriendRequest()
        profileImage.setImage(from: URL(string: ""))
    }
    
    func configure(with notification: Notification) {
        contentLabel.attributedText = addAttributeForMessage(message: notification.message().0, users: notification.message().1)
        timeStampLabel.text = notification.posted_at
        
        /// subcontentLabel 내용 설정
        subcontentLabel.text = { () -> String in
            /// comment 내용 없이 사진, 스티커만 업로드한 경우의 메시지
            if notification.comment_preview?.is_file == "photo" {
                return "· \(notification.sender_preview.username) posted a photo"
            } else if notification.comment_preview?.is_file == "sticker" {
                return "· \(notification.sender_preview.username) posted a sticker"
            }
            if let comment = notification.comment_preview?.content {
                return "· \"" + comment + "\""
            }
            return ""
        }()
        
        /// 프로필 사진 설정
        if let urlString = notification.sender_preview.profile_image {
            profileImage.setImage(from: URL(string: urlString))
        }
        
        /// is_checked에 따라 cell 배경 색깔 설정
        if notification.is_checked {
            self.backgroundColor = .white
        } else {
            self.backgroundColor = .tintColors.mildBlue
        }
        
        if notification.content == .FriendRequest {
            addButtonForFriendRequest()
        }
    }
    
    private func addAttributeForMessage(message: String, users: [String]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: message)
        let NSMessage = message as NSString
        
        for user in users {
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: NSMessage.range(of: "\(user)"))
        }
        
        return attributedString
    }
    
    private func setLayoutForView() {
        contentView.addSubview(profileImage)
        contentView.addSubview(verticalStackForContents)
        horizontalStackForSubcontents.addArrangedSubview(timeStampLabel)
        horizontalStackForSubcontents.addArrangedSubview(subcontentLabel)
        verticalStackForContents.addArrangedSubview(contentLabel)
        verticalStackForContents.addArrangedSubview(horizontalStackForSubcontents)
        contentView.addSubview(detailButton)
        
        profileImage.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8).priority(999)
            make.left.equalTo(contentView.snp.left).offset(15)
            make.height.width.equalTo(68)
        }
        
        verticalStackForContents.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(10)
            make.centerY.equalTo(contentView).priority(999)
            make.right.equalTo(detailButton.snp.left).offset(-16).priority(999)
        }
        
        detailButton.snp.makeConstraints { make in
            make.centerY.equalTo(verticalStackForContents)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-16).priority(999)
        }
    }
    
    private func addButtonForFriendRequest() {
        contentView.addSubview(horizontalStackForButtons)
        
        verticalStackForContents.snp.remakeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(10)
            make.right.equalTo(detailButton.snp.left).offset(-16).priority(999)
            make.top.equalTo(contentView).offset(9)
        }
        
        profileImage.snp.remakeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.left.equalTo(contentView.snp.left).offset(15)
            make.height.width.equalTo(68)
        }
        
        horizontalStackForButtons.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-16).priority(999)
            make.top.equalTo(verticalStackForContents.snp.bottom).offset(8).priority(999)
            make.bottom.equalTo(contentView).offset(-8).priority(999)
        }
        
        self.layoutIfNeeded()
    }
    
    private func removeButtonForFriendRequest() {
        horizontalStackForButtons.removeFromSuperview()
        
        profileImage.snp.remakeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(8).priority(999)
            make.left.equalTo(contentView.snp.left).offset(15)
            make.height.width.equalTo(68)
        }
        
        verticalStackForContents.snp.remakeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(10)
            make.centerY.equalTo(contentView)
            make.right.equalTo(detailButton.snp.left).offset(-16).priority(999)
        }
        
        detailButton.snp.remakeConstraints { make in
            make.centerY.equalTo(verticalStackForContents)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-16).priority(999)
        }
        
        self.layoutIfNeeded()
    }
}
