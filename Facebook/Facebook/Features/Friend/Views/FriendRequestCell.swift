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
        mutualFriendsLabel.isHidden = true
        verticalStackView.removeArrangedSubview(stateLabel)
        stateLabel.removeFromSuperview()
        verticalStackView.addArrangedSubview(horizontalStackView)
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
            make.height.width.equalTo(100).priority(999)
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
        verticalStackView.addArrangedSubview(mutualFriendsLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        mutualFriendsLabel.isHidden = true
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.right.equalToSuperview().inset(10)
        }
    }
    
    func updateState(isAccepted: Bool) {
        stateLabel.text = isAccepted ? "요청 수락함" : "요청 삭제됨"
        verticalStackView.removeArrangedSubview(horizontalStackView)
        horizontalStackView.removeFromSuperview()
        mutualFriendsLabel.isHidden = true
        verticalStackView.addArrangedSubview(stateLabel)
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
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        
        return label
    }()
    
    private let mutualFriendsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        
        return label
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        return stackView
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
    
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 5
    
        return button
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        
        return label
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
    
    func setTimeLabel(time: String) {
        if time == "" { return }
        let timeString = String(time.split(separator: "T")[0] + " " + (time.split(separator: "T")[1]).split(separator: ".")[0])
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        guard let date = dateFormatter.date(from: timeString) else { return }
        let currentDate = Date()
        let calendar = Calendar.current
        let timeGap = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate, to: date)
        if (timeGap.year ?? 0) > 0 {
            timeLabel.text = "\(timeGap.year ?? 0)년 전"
        } else if (timeGap.month ?? 0) > 0 {
            timeLabel.text = "\(timeGap.month ?? 0)개월 전 "
        } else if (timeGap.day ?? 0) > 0 {
            timeLabel.text = "\(timeGap.day ?? 0)일 전 "
        } else if (timeGap.hour ?? 0) > 0 {
            timeLabel.text = "\(timeGap.hour ?? 0)시간 전 "
        } else if (timeGap.minute ?? 0) > 0 {
            timeLabel.text = "\(timeGap.minute ?? 0)분 전 "
        } else {
            timeLabel.text = "방금 전"
        }
    }
}
