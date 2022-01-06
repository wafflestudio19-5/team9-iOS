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
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
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
        profileImage.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1) //white color
        profileImage.layer.borderWidth = 5
        
        editProfileButton.layer.cornerRadius = 5
    }
}

extension MainProfileTableViewCell {
    func setProfileImage(from url: URL?) {
        guard let url = url else { return }
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
        KF.url(url)
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.1)
            .onFailure { error in print("커버 이미지 로딩 실패", error)}
            .set(to: self.profileImage)
    }
    
    func setCoverImage(from url: URL?) {
        guard let url = url else { return }
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 300, height: 300))
        KF.url(url)
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.1)
            .onFailure { error in print("커버 이미지 로딩 실패", error)}
            .set(to: self.coverImage)
    }
}
