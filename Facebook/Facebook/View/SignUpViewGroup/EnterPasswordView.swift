//
//  EnterPasswordView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import UIKit

class EnterPasswordView: UIView {

    let passwordTextField = FacebookTextField(placeholderText: "새로운 비밀번호")
    
    private let verticalStackWithAlertLabel = UIStackView()
    let alertLabel = LabelWithPadding(padding: UIEdgeInsets(top: 10.0, left: 7.0, bottom: 10.0, right: 7.0))
    
    let baseSignUpView = BaseSignUpView(title: "비밀번호 선택", instruction: "다른 사람이 추측할 수 없는 6자 이상의 고유한 비밀번호를 만드세요.")
    
    let nextButton = RectangularSlimButton(title: "가입하기", titleColor: .white, backgroundColor: FacebookColor.blue.color())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAlertLabelText(as text: String) {
        if text != "" {
            verticalStackWithAlertLabel.addArrangedSubview(alertLabel)
            alertLabel.text = text
            return
        }
        verticalStackWithAlertLabel.removeArrangedSubview(alertLabel)
        alertLabel.removeFromSuperview()
    }
    
    private func setStyleForView() {
        passwordTextField.isSecureTextEntry = true
        
        verticalStackWithAlertLabel.axis = .vertical
        verticalStackWithAlertLabel.contentMode = .center
        verticalStackWithAlertLabel.spacing = 14.0
        
        alertLabel.font = .systemFont(ofSize: 12.0)
        alertLabel.textColor = .white
        alertLabel.backgroundColor = .red
        alertLabel.numberOfLines = 0
        alertLabel.lineBreakStrategy = .pushOut
    }
    
    private func setLayoutForView() {

        self.addSubview(baseSignUpView)
        self.addSubview(verticalStackWithAlertLabel)
        self.addSubview(nextButton)
        
        verticalStackWithAlertLabel.addArrangedSubview(passwordTextField)
        
        baseSignUpView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackWithAlertLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            baseSignUpView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            baseSignUpView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            baseSignUpView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            verticalStackWithAlertLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            verticalStackWithAlertLabel.topAnchor.constraint(equalTo: baseSignUpView.bottomAnchor, constant: 24.0),
            verticalStackWithAlertLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),

            nextButton.topAnchor.constraint(equalTo: verticalStackWithAlertLabel.bottomAnchor, constant: 16.0),
            nextButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 72.0),
            nextButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -72.0),
        ])
    }
}
