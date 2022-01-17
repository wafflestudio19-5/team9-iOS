//
//  MainProfileTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit
import RxSwift
import Kingfisher

class MainProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selfIntroLabel: UILabel!
    @IBOutlet weak var coverLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var coverImageButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
          super.prepareForReuse()
          disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(profileImageUrl: String, coverImageUrl: String, name: String, selfIntro: String, buttonText: String) {
        nameLabel.text = name
        selfIntroLabel.text = selfIntro
        
        editProfileButton.setTitle(buttonText, for: .normal)
        if buttonText == "프로필 편집" {
            editProfileButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        } else {
            editProfileButton.setImage(UIImage(systemName: "person.fill.badge.plus"), for: .normal)
        }
        
        
        if profileImageUrl != "" {
            loadProfileImage(from: URL(string: profileImageUrl))
        } else {
            profileImage.image = UIImage(systemName: "person.fill")
        }
        
        if coverImageUrl != "" {
            loadCoverImage(from: URL(string: coverImageUrl))
        } else {
            coverImage.image = UIImage()
        }
    }
    
    private func setStyle() {
        self.coverImage.layer.zPosition = 0
        self.profileImage.layer.zPosition = 1
        self.coverImageButton.layer.zPosition = 1
        self.coverLabel.layer.zPosition = 1
        
        coverImageButton.layer.cornerRadius = 5
        
        coverImage.layer.cornerRadius = 15
        coverImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.white.cgColor//white color
        profileImage.layer.borderWidth = 5
        
        editProfileButton.layer.cornerRadius = 5
    }
}

extension MainProfileTableViewCell {
    func loadProfileImage(from url: URL?) {
        guard let url = url else { return }
        
        KF.url(url)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.1)
            .onFailure { error in print("프로필 이미지 로딩 실패", error)}
            .set(to: self.profileImage)
    }
    
    func loadCoverImage(from url: URL?) {
        guard let url = url else { return }
        
        KF.url(url)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.1)
            .onFailure { error in print("커버 이미지 로딩 실패", error)}
            .set(to: self.coverImage)        
    }
}
