//
//  CreateHeaderView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/21.
//

import UIKit

class CreateHeaderView: UIView {

    /// 피드 상단, 게시자의 프로필 이미지와 닉네임, 작성 시각 등이 표시되는 뷰
    
    init(imageWidth: CGFloat = .profileImageSize) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageWidth)
            make.leading.top.bottom.equalToSuperview().inset(15)
        }
        
        let labelStack = UIView()
        labelStack.addSubview(authorNameLabel)
        labelStack.addSubview(scopeButton)
        
        authorNameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(labelStack)
        }

        scopeButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(labelStack)
            make.top.equalTo(authorNameLabel.snp.bottom)
        }
        
        self.bringSubviewToFront(labelStack)
        
        self.addSubview(labelStack)
        labelStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
        }
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        profileImageView.setImage(from: StateManager.of.user.profile.profile_image)
        authorNameLabel.text = StateManager.of.user.profile.username
//        scopeButton.configurePublic()
    }
    
    // Profile Image가 표시되는 뷰 (현재는 아이콘으로 구현)
    let profileImageView = ProfileImageView()
    
    // 작성자 이름 라벨
    let authorNameLabel: InfoLabel = InfoLabel(color: .label, size: 16, weight: .medium)
    let scopeButton = RectangularSlimButton(title: "efwfew", titleColor: .blue, backgroundColor: .yellow)
}

