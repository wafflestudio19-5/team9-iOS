//
//  LoginView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import UIKit
import SnapKit

class LoginView: UIView {
    
    let logoImage = UIImageView(image: UIImage(named: "WafflebookLogo"))
    
    let loginButton = RectangularSlimButton(title: "로그인", titleColor: .white, backgroundColor: .tintColors.blue, needsIndicator: true)
    
    let kakaoLoginButton = UIImageView(image: UIImage(named: "KakaoLoginButton"))
    
    let createAccountButton = RectangularSlimButton(title: "새 계정 만들기", titleColor: .tintColors.blue, backgroundColor: .tintColors.mildBlue)
    
    let emailTextField = FacebookTextField(placeholderText: "이메일 주소")
    let passwordTextField = FacebookTextField(placeholderText: "비밀번호")
    
    var bottomConstraint: NSLayoutConstraint?
    
    let orLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView() {
        emailTextField.autocapitalizationType = .none
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        
        orLabel.text = "또는"
        orLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        orLabel.textColor = .darkGray
        
        kakaoLoginButton.contentMode = .scaleAspectFit
        
        logoImage.contentMode = .scaleAspectFill
        logoImage.layer.cornerCurve = .continuous
        logoImage.layer.cornerRadius = 10.0
        logoImage.clipsToBounds = true
    }

    private func setLayoutForView() {
        self.addSubview(loginButton)
        self.addSubview(kakaoLoginButton)
        self.addSubview(emailTextField)
        self.addSubview(passwordTextField)
        self.addSubview(createAccountButton)
        self.addSubview(orLabel)
        
        logoImage.snp.makeConstraints { make in
            make.width.height.equalTo(36.0)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16.0)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16.0)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16.0).priority(999)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(4.0)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16.0)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16.0).priority(999)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12.0)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16.0)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16.0).priority(999)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10.0)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16.0)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16.0).priority(999)
            make.height.equalTo(kakaoLoginButton.snp.width).multipliedBy(0.15)
        }
        
        orLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(createAccountButton.snp.top).offset(-16.0)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16.0)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16.0).priority(999)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
