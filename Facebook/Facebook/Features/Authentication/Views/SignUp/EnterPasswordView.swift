//
//  EnterPasswordView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import UIKit
import SnapKit

class EnterPasswordView: BaseSignUpView {

    let passwordTextField = FacebookTextField(placeholderText: "새로운 비밀번호")

    lazy var nextButton = RectangularSlimButton(title: "가입하기", titleColor: .white, backgroundColor: .tintColors.blue, needsIndicator: true)
    
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

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(verticalStackWithAlertLabel.snp.bottom).offset(16)
            make.left.right.equalTo(self.safeAreaLayoutGuide).inset(72)
        }
    }
}
