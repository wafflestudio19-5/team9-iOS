//
//  SearchResultCell.swift.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/13.
//

import Foundation
import UIKit
import RxSwift

class SearchResultCell: UITableViewCell {
    var refreshingBag = DisposeBag()
    static let reuseIdentifier = "SearchResultCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.width = UIScreen.main.bounds.width  // important for initial layout
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        contentView.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(CGFloat.profileImageSize)
            make.leading.equalTo(contentView).offset(CGFloat.standardLeadingMargin)
        }
        
        let labelStack = UIView()
        labelStack.addSubview(nameLabel)
        labelStack.addSubview(friendLabel)
        contentView.addSubview(labelStack)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(labelStack)
        }
        friendLabel.snp.makeConstraints { make in
            make.bottom.leading.equalTo(labelStack)
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(20)
        }
        
        labelStack.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(CGFloat.standardLeadingMargin)
            make.centerY.equalTo(contentView)
        }
        
    }
    
    private func getFriendLabelText(user: User) -> String {
        var friendTexts = (user.is_friend ?? false) ? ["친구"] : []
        if let count = user.mutual_friends?.count, count > 0 {
            friendTexts.append("함께 아는 친구 \(count)명")
        }
        return friendTexts.joined(separator: " · ")
    }
    
    func configure(with user: User) {
        profileImage.setImage(from: user.profile_image)
        nameLabel.text = user.username
        let friendLabelText = getFriendLabelText(user: user)
        friendLabel.isHidden = friendLabelText.isEmpty
        friendLabel.text = friendLabelText
        friendLabel.snp.updateConstraints { make in
            make.height.equalTo(friendLabelText.isEmpty ? 0 : 16)
        }
    }
    
    let profileImage = ProfileImageView()
    let nameLabel = InfoLabel(color: .label, size: 16, weight: .medium)
    let friendLabel = InfoLabel(size: 14)
}
