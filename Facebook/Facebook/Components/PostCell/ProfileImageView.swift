//
//  ProfileImageView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit
import Kingfisher

class ProfileImageView: UIView {
    private var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .secondarySystemFill
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width
        self.backgroundColor = .grayscales.bubbleFocused
        
        setImage(from: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    convenience init(from url: URL?) {
        self.init(frame: .zero)
        setImage(from: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func setImage(from url: URL?) {
        guard let url = url else {
            imageView.image = UIImage(systemName: "person.fill")
            imageView.snp.remakeConstraints { make in
                make.height.equalTo(30)
                make.centerX.centerY.equalTo(self)
            }
            return
        }
        imageView.snp.remakeConstraints { make in
            make.edges.equalTo(0)
        }
        let processor = DownsamplingImageProcessor(size: CGSize(width: 400, height: 400))
        KF.url(url)
          .setProcessor(processor)
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .fade(duration: 0.1)
          .onFailure { error in print("로딩 실패", error)}
          .set(to: self.imageView)
    }
    
}
