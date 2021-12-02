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
    
    let idTextField = FacebookTextField(placeholderText: "전화번호 또는 이메일 주소", width: UIScreen.main.bounds.width - 32.0)
    let passwordTextField = FacebookTextField(placeholderText: "비밀번호", width: UIScreen.main.bounds.width - 32.0)
    
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
        
        // createAccountButton의 하단 Constraint 설정
        bottomConstraint = createAccountButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        
        guard let bottomConstraint = bottomConstraint else {
            return
        }
        
        NSLayoutConstraint.activate([
            idTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50.0),
            idTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 4.0),
            passwordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12.0),
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16.0),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 0.0),
            backButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            orLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            orLabel.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -18.0),
            
            createAccountButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bottomConstraint,
        ])
    }
}
