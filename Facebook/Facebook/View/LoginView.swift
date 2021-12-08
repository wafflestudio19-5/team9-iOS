//
//  LoginView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import UIKit

class LoginView: UIView {
    
    let loginButton = RectangularSlimButton(title: "로그인", titleColor: .systemGray3, backgroundColor: FacebookColor.blue.color())
    let forgotPasswordButton = RectangularSlimButton(title: "비밀번호를 잊으셨나요?", titleColor: FacebookColor.blue.color(), backgroundColor: .white)
    let backButton = RectangularSlimButton(title: "돌아가기", titleColor: FacebookColor.blue.color(), backgroundColor: .white)
    let createAccountButton = RectangularSlimButton(title: "새 계정 만들기", titleColor: FacebookColor.blue.color(), backgroundColor: FacebookColor.mildBlue.color())
    
    let idTextField = FacebookTextField(placeholderText: "이메일 주소")
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
        orLabel.text = "또는"
        orLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        orLabel.textColor = .darkGray
    }

    private func setLayoutForView() {
        self.addSubview(loginButton)
        self.addSubview(forgotPasswordButton)
        self.addSubview(backButton)
        self.addSubview(idTextField)
        self.addSubview(passwordTextField)
        self.addSubview(createAccountButton)
        self.addSubview(orLabel)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // FacebookTextField 및 RectangularSlimButton의 UITemporaryLayoutHeight와의 충돌 방지
        layoutIfNeeded()
        
        // createAccountButton의 하단 Constraint 설정
        bottomConstraint = createAccountButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        
        guard let bottomConstraint = bottomConstraint else {
            return
        }
        
        NSLayoutConstraint.activate([
            idTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50.0),
            idTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            idTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            
            passwordTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 4.0),
            passwordTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            passwordTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12.0),
            loginButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            loginButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16.0),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 0.0),
            backButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            orLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            orLabel.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -18.0),
            
            createAccountButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            createAccountButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            bottomConstraint,
        ])
    }
}
