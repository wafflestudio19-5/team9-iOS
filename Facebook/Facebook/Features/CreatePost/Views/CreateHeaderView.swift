//
//  CreateHeaderView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/21.
//

import UIKit
import RxSwift

enum Scope: Int {
    case all = 3
    case friends = 2
    case secret = 1
}

class CreateHeaderView: UIView {
    
    /// 피드 상단, 게시자의 프로필 이미지와 공개 범위 버튼이 표시되는 뷰
    
    var selectedScope: Scope = .all {
        didSet {
            self.configureScopeButton()
        }
    }
    var disposeBag = DisposeBag()
    
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
            make.top.equalTo(authorNameLabel.snp.bottom).offset(3)
        }
        
        self.addSubview(labelStack)
        labelStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            make.trailing.equalTo(0).offset(CGFloat.standardTrailingMargin)
        }
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        profileImageView.setImage(from: StateManager.of.user.profile.profile_image)
        authorNameLabel.text = StateManager.of.user.profile.username
        configureScopeButton()
        scopeButton.menu = scopeMenu
        scopeButton.showsMenuAsPrimaryAction = true
    }
    
    func configureScopeButton() {
        switch selectedScope {
        case .all:
            scopeButton.configurePublic()
        case .friends:
            scopeButton.configureFriendsOnly()
        case .secret:
            scopeButton.configurePrivate()
        }
    }
    
    let profileImageView = ProfileImageView()
    let authorNameLabel: InfoLabel = InfoLabel(color: .label, size: 15, weight: .medium)
    let scopeButton = ScopeButton(size: 12, weight: .regular)
    
    private var scopeMenues: [UIAction] {
        return [
            UIAction(title: "전체 공개", image: UIImage(systemName: "globe.asia.australia"), handler: { _ in
                self.selectedScope = .all
            }),
            UIAction(title: "친구만", image: UIImage(systemName: "person.2"), handler: { _ in
                self.selectedScope = .friends
            }),
            UIAction(title: "나만 보기", image: UIImage(systemName: "lock"), handler: { _ in
                self.selectedScope = .secret
            })
        ]
    }
    
    private var scopeMenu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: scopeMenues)
    }
}

