//
//  EnterPasswordView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import UIKit

class EnterPasswordView: UIView {

    let passwordTextField = FacebookTextField(placeholderText: "새로운 비밀번호")
    
    let baseSignUpView = BaseSignUpView(title: "비밀번호 선택", instruction: "다른 사람이 추측할 수 없는 6자 이상의 고유한 비밀번호를 만드세요.")
    
    let nextButton = RectangularSlimButton(title: "가입하기", titleColor: .white, backgroundColor: FacebookColor.blue.color())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {

        self.addSubview(baseSignUpView)
        self.addSubview(passwordTextField)
        self.addSubview(nextButton)
        
        baseSignUpView.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            baseSignUpView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            baseSignUpView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            baseSignUpView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            passwordTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            passwordTextField.topAnchor.constraint(equalTo: baseSignUpView.bottomAnchor, constant: 24.0),
            passwordTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),

            nextButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16.0),
            nextButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 72.0),
            nextButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -72.0),
        ])
    }
}
