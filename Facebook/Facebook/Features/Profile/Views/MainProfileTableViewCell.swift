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
    
    func configureCell(profileImageUrl: String, coverImageUrl: String, name: String, selfIntro: String) {
        nameLabel.text = name
        selfIntroLabel.text = selfIntro
        
        if profileImageUrl != "" {
            loadProfileImage(from: URL(string: profileImageUrl))
        }
        
        if coverImageUrl != "" {
            loadCoverImage(from: URL(string: coverImageUrl))
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
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
        KF.url(url)
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.1)
            .onFailure { error in print("프로필 이미지 로딩 실패", error)}
            .set(to: self.profileImage)
    }
    
    func loadCoverImage(from url: URL?) {
        guard let url = url else { return }
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 300, height: 300))
        KF.url(url)
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.1)
            .onFailure { error in print("커버 이미지 로딩 실패", error)}
            .set(to: self.coverImage)
        
        coverLabel.isHidden = true
        coverImageButton.isHidden = true
        
    }
}
