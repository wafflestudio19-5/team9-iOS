//
//  EnterEmailView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/08.
//

import UIKit

class EnterEmailView: BaseSignUpView {

    let emailTextField = FacebookTextField(placeholderText: "이메일 주소")

    let nextButton = RectangularSlimButton(title: "다음", titleColor: .white, backgroundColor: FacebookColor.blue.color())
    
    init() {
        super.init(title: "이메일 주소를 입력하세요", instruction: "회원님에게 연락할 수 있는 이메일 주소를 입력하세요. 나중에 프로필에서 이 정보를 숨길 수 있습니다.")
        
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
        emailTextField.autocapitalizationType = .none
    }
    
    private func setLayoutForView() {

        self.addCustomView(view: emailTextField)
        self.addSubview(nextButton)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: verticalStackWithAlertLabel.bottomAnchor, constant: 16.0),
            nextButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 72.0),
            nextButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -72.0),
        ])
    }
}
