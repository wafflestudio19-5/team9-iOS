//
//  EnterEmailView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/08.
//

import UIKit

class EnterEmailView: UIView {

    let emailTextField = FacebookTextField(placeholderText: "이메일 주소")
    
    private let verticalStackWithAlertLabel = UIStackView()
    
    let alertLabel = LabelWithPadding(padding: UIEdgeInsets(top: 10.0, left: 7.0, bottom: 10.0, right: 7.0))
    
    let baseSignUpView = BaseSignUpView(title: "이메일 주소를 입력하세요", instruction: "회원님에게 연락할 수 있는 이메일 주소를 입력하세요. 나중에 프로필에서 이 정보를 숨길 수 있습니다.")
    
    let nextButton = RectangularSlimButton(title: "다음", titleColor: .white, backgroundColor: FacebookColor.blue.color())
    
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
        emailTextField.autocapitalizationType = .none
        
        verticalStackWithAlertLabel.axis = .vertical
        verticalStackWithAlertLabel.contentMode = .center
        verticalStackWithAlertLabel.spacing = 14.0
        
        alertLabel.font = .systemFont(ofSize: 12.0)
        alertLabel.textColor = .white
        alertLabel.backgroundColor = .red
    }
    
    private func setLayoutForView() {

        self.addSubview(baseSignUpView)
        self.addSubview(verticalStackWithAlertLabel)
        self.addSubview(nextButton)
        
        verticalStackWithAlertLabel.addArrangedSubview(emailTextField)
        
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
