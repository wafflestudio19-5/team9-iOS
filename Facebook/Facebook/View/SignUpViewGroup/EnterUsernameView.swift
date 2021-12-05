//
//  EnterUsernameView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/06.
//

import UIKit

class EnterUsernameView: UIView {

    let firstNameTextField = FacebookTextField(placeholderText: "성")
    let lastNameTextField = FacebookTextField(placeholderText: "이름")
    
    let horizontalStackForTextFields = UIStackView()
    
    let baseSignUpView = BaseSignUpView(title: "이름이 무엇인가요?", instruction: "실명을 입력하세요.")
    
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
    
    private func setStyleForView() {
        horizontalStackForTextFields.axis = .horizontal
        horizontalStackForTextFields.contentMode = .center
        horizontalStackForTextFields.distribution = .fillEqually
        horizontalStackForTextFields.spacing = 10.0
    }
    
    private func setLayoutForView() {

        horizontalStackForTextFields.addArrangedSubview(firstNameTextField)
        horizontalStackForTextFields.addArrangedSubview(lastNameTextField)
        
        self.addSubview(baseSignUpView)
        self.addSubview(horizontalStackForTextFields)
        self.addSubview(nextButton)
        
        baseSignUpView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackForTextFields.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            baseSignUpView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            baseSignUpView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            baseSignUpView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            horizontalStackForTextFields.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            horizontalStackForTextFields.topAnchor.constraint(equalTo: baseSignUpView.bottomAnchor, constant: 24.0),
            horizontalStackForTextFields.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),
            
            nextButton.topAnchor.constraint(equalTo: horizontalStackForTextFields.bottomAnchor, constant: 16.0),
            nextButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 72.0),
            nextButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -72.0),
        ])
    }
}
