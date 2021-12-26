//
//  Header&FooterView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/23.
//

import Foundation
import UIKit

class HeaderView: UIView {
    
    let titleText = "회원님을 소개할 항목을 구성해보세요"
    let subTitleText = "선택하신 상세 정보는 전체 공개됩니다."
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
        ])
        
        self.addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
        ])
        
        self.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = subTitleText
        label.textColor = .systemGray4
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .lightGray
        return divider
    }()
}

class FooterView: UIView {
    let buttonLabel = "저장"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50)
    
        self.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(buttonLabel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
}

