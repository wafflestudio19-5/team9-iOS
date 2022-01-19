//
//  EnterUsernameView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/06.
//

import UIKit

class EnterUsernameView: BaseSignUpView {

    let firstNameTextField = FacebookTextField(placeholderText: "이름")
    let lastNameTextField = FacebookTextField(placeholderText: "성")
    
    let horizontalStackForTextFields = UIStackView()
    
    let nextButton = RectangularSlimButton(title: "다음", titleColor: .white, backgroundColor: .tintColors.blue)
    
    init() {
        super.init(title: "이름이 무엇인가요?", instruction: "실명을 입력하세요.")
        
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
        horizontalStackForTextFields.axis = .horizontal
        horizontalStackForTextFields.contentMode = .center
        horizontalStackForTextFields.distribution = .fillEqually
        horizontalStackForTextFields.spacing = 10.0
    }
    
    private func setLayoutForView() {

        horizontalStackForTextFields.addArrangedSubview(firstNameTextField)
        horizontalStackForTextFields.addArrangedSubview(lastNameTextField)
        
        self.addCustomView(view: horizontalStackForTextFields)
        self.addSubview(nextButton)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: verticalStackWithAlertLabel.bottomAnchor, constant: 16.0),
            nextButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 72.0),
            nextButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -72.0),
        ])
    }
}
