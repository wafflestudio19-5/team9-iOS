//
//  LoginView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import UIKit

class LoginView: UIView {
    
    let logoImage = UIImageView(image: UIImage(named: "WafflebookLogo"))
    
    let loginButton = RectangularSlimButton(title: "로그인", titleColor: .systemGray3, backgroundColor: FacebookColor.blue.color())
    
    let kakaoLoginButton = UIImageView(image: UIImage(named: "KakaoLoginButton"))
    
    let createAccountButton = RectangularSlimButton(title: "새 계정 만들기", titleColor: FacebookColor.blue.color(), backgroundColor: FacebookColor.mildBlue.color())
    
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
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        // FacebookTextField 및 RectangularSlimButton의 UITemporaryLayoutHeight와의 충돌 방지
        layoutIfNeeded()
        
        // createAccountButton의 하단 Constraint 설정
        bottomConstraint = createAccountButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        
        guard let bottomConstraint = bottomConstraint else {
            return
        }
        
        NSLayoutConstraint.activate([
            
            logoImage.widthAnchor.constraint(equalToConstant: 36.0),
            logoImage.heightAnchor.constraint(equalToConstant: 36.0),
            
            emailTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            emailTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            emailTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 4.0),
            passwordTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            passwordTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12.0),
            loginButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            loginButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            
            kakaoLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10.0),
            kakaoLoginButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            kakaoLoginButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            kakaoLoginButton.heightAnchor.constraint(equalTo: kakaoLoginButton.widthAnchor, multiplier: 0.15),
            
            orLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            orLabel.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -16.0),
            
            createAccountButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            createAccountButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            bottomConstraint,
        ])
    }
}
