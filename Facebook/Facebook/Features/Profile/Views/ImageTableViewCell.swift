//
//  ProfileImageTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/20.
//

import UIKit
import RxSwift
import Kingfisher

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    var disposeBag = DisposeBag()
    
    enum Style {
        case profileImage
        case coverImage
    }
    
    var cellStyle: Style = .profileImage
    
    override func prepareForReuse() {
          super.prepareForReuse()
          disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(cellStyle: Style, imageUrl: String){
        self.cellStyle = cellStyle
        if imageUrl != "" {
            loadImage(from: URL(string: imageUrl))
        }else {
            switch self.cellStyle {
            case .profileImage:
                imgView.image = UIImage(systemName: "person.circle.fill")
                NSLayoutConstraint.activate([
                    imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
                    imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
                ])
            case .coverImage:
                imgView.image = UIImage(systemName: "photo")
                NSLayoutConstraint.activate([
                    imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
                    imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
                ])
            }
        }
    }
}

extension ImageTableViewCell {
    private func loadImage(from url: URL?) {
        guard let url = url else { return }
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
        KF.url(url)
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.1)
            .onFailure { error in print("프로필 이미지 로딩 실패", error)}
            .set(to: self.imgView)
        
        switch cellStyle {
        case .profileImage:
            imgView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            imgView.layer.cornerRadius = imgView.frame.height / 2
            imgView.clipsToBounds = true
            imgView.layer.borderColor = UIColor.white.cgColor//white color
            imgView.layer.borderWidth = 5
        case .coverImage:
            NSLayoutConstraint.activate([
                imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
                imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
            ])
        }
    }
}
