//
//  ProfileInfoHeaderView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit
import SwiftUI
import SnapKit

class AuthorInfoHeaderView: UIView {

    /// 피드 상단, 게시자의 프로필 이미지와 닉네임, 작성 시각 등이 표시되는 뷰
    
    init(imageWidth: CGFloat = .profileImageSize) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.text = "일론 머스크"  // preview 용도
        postDateLabel.text = "17시간 전"
        
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerY.leading.equalTo(self)
            make.width.height.equalTo(imageWidth)
        }
        
        let labelStack = UIView()
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.addSubview(authorNameLabel)
        labelStack.addSubview(postDateLabel)
        labelStack.addSubview(scopeSymbol)
        
        authorNameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(0)
        }
        
        postDateLabel.snp.makeConstraints { make in
            make.leading.bottom.equalTo(0)
            make.top.equalTo(authorNameLabel.snp.bottom)
        }
        
        scopeSymbol.snp.makeConstraints { make in
            make.centerY.equalTo(postDateLabel)
            make.leading.equalTo(postDateLabel.snp.trailing)
        }
        
        self.addSubview(labelStack)
        labelStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(CGFloat.standardTrailingMargin)
        }
        
        self.addSubview(ellipsisButton)
        ellipsisButton.snp.makeConstraints { make in
            make.trailing.equalTo(0)
            make.centerY.equalTo(self).offset(-10)
            make.width.equalTo(20)
        }
    }
    
    func configure(with post: Post) {
        authorNameLabel.text = post.author?.username ?? "알 수 없음"
        postDateLabel.text = post.posted_at
        profileImageView.setImage(from: post.author?.profile_image)
        
        if let scope = post.scope {
            scopeSymbol.isHidden = false
            scopeSymbol.image = scope.getImage(fill: true, size: 12)
            postDateLabel.text? += " · "
        } else {
            scopeSymbol.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Profile Image가 표시되는 뷰 (현재는 아이콘으로 구현)
    let profileImageView = ProfileImageView()
    
    // 작성자 이름 라벨
    let authorNameLabel: InfoLabel = InfoLabel(color: .label, size: 16, weight: .medium)
    
    // 작성 시간 라벨
    private let postDateLabel: UILabel = InfoLabel(size: 12)
    private var scopeSymbol: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    // 점 세개
    var ellipsisButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .grayscales.label
        configuration.baseBackgroundColor = .clear
        configuration.image = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .black))
        let button = UIButton(configuration: configuration)
        return button
    }()
}


struct AuthorInfoHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let authorInfoHeaderView = AuthorInfoHeaderView()
        SwiftUIRepresentable(view: authorInfoHeaderView)
    }
}
