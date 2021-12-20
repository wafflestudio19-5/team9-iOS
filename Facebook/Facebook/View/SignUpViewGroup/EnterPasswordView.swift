//
//  EnterPasswordView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import UIKit

class EnterPasswordView: BaseSignUpView {

    let passwordTextField = FacebookTextField(placeholderText: "새로운 비밀번호")

    let nextButton = RectangularSlimButton(title: "가입하기", titleColor: .white, backgroundColor: FacebookColor.blue.color())
    
    init() {
        super.init(title: "비밀번호 선택", instruction: "다른 사람이 추측할 수 없는 6자 이상의 고유한 비밀번호를 만드세요.")
        
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAlertLabelText(as text: String) {
        if !text.isEmpty { showAlertLabel(as: text) }
        else { hideAlertLabel() }
    }
    
    private func setStyleForView() {
        passwordTextField.isSecureTextEntry = true
    }
    
    private func setLayoutForView() {

        self.addCustomView(view: passwordTextField)
        self.addSubview(nextButton)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: verticalStackWithAlertLabel.bottomAnchor, constant: 16.0),
            nextButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 72.0),
            nextButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -72.0),
        ])
    }
}
