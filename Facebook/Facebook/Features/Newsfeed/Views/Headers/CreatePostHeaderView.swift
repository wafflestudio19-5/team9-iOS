//
//  CreatePostHeader.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/22.
//

import Foundation
import UIKit
import RxSwift

class CreatePostHeaderView: UIView {
    private let buttonLabel = "무슨 생각을 하고 계신가요?"
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        bind()
    }
    
    private func bind() {
        StateManager.of.user
            .asObservable()
            .bind { [weak self] profile in
                self?.profileImage.setImage(from: URL(string: profile.profile_image ?? ""))
            }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: .profileImageSize),
            profileImage.heightAnchor.constraint(equalToConstant: .profileImageSize),
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        ])
        
        self.addSubview(createPostButton)
        NSLayoutConstraint.activate([
            createPostButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            createPostButton.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 5),
            createPostButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
        
        self.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 5),
            divider.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private var profileImage: ProfileImageView = {
        let imageView = ProfileImageView()
        return imageView
    }()
    
    lazy var createPostButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .leading
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        var configuration = UIButton.Configuration.tinted()
        configuration.baseForegroundColor = .grayscales.label
        configuration.contentInsets = .init(.init(top: 7, leading: 5, bottom: 7, trailing: 5))
        configuration.attributedTitle = AttributedString(buttonLabel, attributes: container)
        button.configuration = configuration
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.baseBackgroundColor = button.isTouchInside ? .lightGray : .clear
            button.configuration = config
        }
        return button
    }()
    
    private let divider = Divider(color: .grayscales.newsfeedDivider)
}
