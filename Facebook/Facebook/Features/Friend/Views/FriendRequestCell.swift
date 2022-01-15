//
//  FriendRequestCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/14.
//

import UIKit
import RxSwift
import Kingfisher

class FriendRequestCell: UITableViewCell {

    var refreshingBag = DisposeBag()
    var permanentBag = DisposeBag()
    static let reuseIdentifier = "FriendRequestCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.width = UIScreen.main.bounds.width  // important for initial layout
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.refreshingBag = DisposeBag()
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
    }
    
    private func setLayout() {
        contentView.addSubview(profileImage)
        profileImage.snp.remakeConstraints { make in
            make.height.width.equalTo(100)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(CGFloat.standardLeadingMargin)
        }
        
        contentView.addSubview(verticalStackView)
        verticalStackView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(15)
        }
    
        horizontalStackView.addArrangedSubview(acceptButton)
        horizontalStackView.addArrangedSubview(deleteButton)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
    }

    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let nameLabel = UILabel()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
    
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 5
    
        return button
    }()
}

extension FriendRequestCell {
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
