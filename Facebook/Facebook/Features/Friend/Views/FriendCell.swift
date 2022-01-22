//
//  FriendCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/13.
//

import UIKit
import RxSwift
import Kingfisher

class FriendCell: UITableViewCell {
    
    var refreshingBag = DisposeBag()
    var permanentBag = DisposeBag()
    static let reuseIdentifier = "FriendCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.width = UIScreen.main.bounds.width  // important for initial layout
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.refreshingBag = DisposeBag()
        mutualFriendsLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with friend: User) {
        nameLabel.text = friend.username
        if let imageUrl = friend.profile_image {
            loadProfileImage(from: URL(string: imageUrl))
        } else {
            profileImage.image = UIImage(systemName: "person.crop.circle.fill")
            profileImage.tintColor = .systemGray5
        }
        
        guard let friendInfo = friend.mutual_friends else {
            return
        }
        if friendInfo.count != 0  {
            mutualFriendsLabel.text = "함께 아는 친구 \(friendInfo.count)명"
            mutualFriendsLabel.isHidden = false
        }
    }
    
    private func setLayout() {
        contentView.addSubview(profileImage)
        profileImage.snp.remakeConstraints { make in
            make.height.width.equalTo(50).priority(999)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(CGFloat.standardLeadingMargin)
        }
        profileImage.layer.cornerRadius = 25
        
        contentView.addSubview(verticalStackView)
        verticalStackView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(15)
        }
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(mutualFriendsLabel)
        mutualFriendsLabel.isHidden = true
        
        contentView.addSubview(menuButton)
        menuButton.snp.remakeConstraints { make in
            make.height.width.equalTo(30)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
        }
    }

    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        
        return label
    }()
    
    private let mutualFriendsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        
        return label
    }()
    
    let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
    
        return button
    }()
}

extension FriendCell {
    func loadProfileImage(from url: URL?) {
        guard let url = url else { return }
        
        KF.url(url)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.1)
            .onFailure { error in print("프로필 이미지 로딩 실패", error)}
            .set(to: self.profileImage)
    }
}
