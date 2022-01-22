//
//  CreateHeaderView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/21.
//

import UIKit
import RxSwift

class CreateHeaderView: UIView {
    
    /// 피드 상단, 게시자의 프로필 이미지와 공개 범위 버튼이 표시되는 뷰
    
    var selectedScope: Scope = .all {
        didSet {
            scopeButton.configure(with: selectedScope)
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
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
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
        scopeButton.menu = scopeMenu
        scopeButton.showsMenuAsPrimaryAction = true
        scopeButton.configure(with: .all)
    }
    
    let profileImageView = ProfileImageView()
    let authorNameLabel: InfoLabel = InfoLabel(color: .label, size: 15, weight: .semibold)
    let scopeButton = ScopeButton(size: 12, weight: .regular)
    
    private var scopeMenues: [UIAction] {
        return Scope.allCases.map { scope in
            return UIAction(title: scope.text, image: scope.getImage(fill: false, color: .label), handler: { _ in
                self.selectedScope = scope
            })
        }
    }
    
    private var scopeMenu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: scopeMenues)
    }
}
