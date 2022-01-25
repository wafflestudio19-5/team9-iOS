//
//  FriendGridCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/15.
//

import UIKit
import Kingfisher

class FriendGridCell: UICollectionViewCell {
    static let reuseIdentifier = "FriendGridCell"
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        return label
    }()
    
    private let mutualFriendsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .gray
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setStyle()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mutualFriendsLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with friendData: User, isMe: Bool) {
        nameLabel.text = friendData.username
        displayMedia(from: URL(string: friendData.profile_image ?? ""))
        
        if !isMe {
            verticalStackView.snp.updateConstraints { make in
                make.height.equalTo(35)
            }
            mutualFriendsLabel.isHidden = false
            mutualFriendsLabel.text = (friendData.mutual_friends != nil) ? "함께 아는 친구 \(friendData.mutual_friends?.count ?? 0)명" : "   "
        }
    }
    
    private func setLayout() {
        contentView.addSubview(profileImage)
        profileImage.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(verticalStackView)
        verticalStackView.snp.remakeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(profileImage.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(10)
        }
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(mutualFriendsLabel)
        mutualFriendsLabel.isHidden = true
    }
    
    private func setStyle() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
}

// MARK: From URL
extension FriendGridCell {
    func displayMedia(from url: URL?) {
        guard let url = url else {
            profileImage.image = UIImage(systemName: "person.fill")
            profileImage.tintColor = .white
            profileImage.backgroundColor = .systemGray5
            return
        }

        let processor = DownsamplingImageProcessor(size: CGSize(width: 400, height: 400))
        KF.url(url)
          .setProcessor(processor)
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .fade(duration: 0.1)
          .onFailure { error in print("로딩 실패", error)}
          .set(to: profileImage)
    }
}
