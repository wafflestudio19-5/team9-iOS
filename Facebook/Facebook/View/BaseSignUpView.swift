//
//  BaseSignUpView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/03.
//

import UIKit

class BaseSignUpView: UIView {
    
    private let titleLabel = UILabel()
    private let instructionLabel = UILabel()
    private let nextButton = RectangularSlimButton(title: "다음", titleColor: .white, backgroundColor: FacebookColor.blue.color(), width: 240.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required convenience init(title: String, instruction: String, bottomView: UIView) {
        self.init(frame: CGRect.zero)
        setLabelText(title: title, instruction: instruction)
        setStyleForView()
        setLayoutForView(including: bottomView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLabelText(title: String, instruction: String) {
        titleLabel.text = title
        instructionLabel.text = instruction
    }
    
    private func setStyleForView() {
        titleLabel.font = .systemFont(ofSize: 17.0, weight: .bold)
        instructionLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
    }
    
    private func setLayoutForView(including customBottomView: UIView) {
        self.addSubview(titleLabel)
        self.addSubview(instructionLabel)
        self.addSubview(customBottomView)
        self.addSubview(nextButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        customBottomView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            titleLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.0),
            instructionLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            instructionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 48.0),
            instructionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -48.0),
            
            customBottomView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16.0),
            customBottomView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
//            customBottomView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 48.0),
//            customBottomView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -48.0),
            
            nextButton.topAnchor.constraint(equalTo: customBottomView.bottomAnchor, constant: 18.0),
            nextButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])
    }

}
