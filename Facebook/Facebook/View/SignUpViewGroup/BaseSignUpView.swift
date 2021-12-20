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
    
    let alertLabel = LabelWithPadding(padding: UIEdgeInsets(top: 10.0, left: 7.0, bottom: 10.0, right: 7.0))
    let verticalStackWithAlertLabel = UIStackView()
    
    var customView: UIView = UIView()
    
    init(title: String, instruction: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        setLabelText(title: title, instruction: instruction)
        setStyleForView()
        setLayoutForView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: CGRect.zero)
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAlertLabel(as text: String, setOnTop: Bool = false) {
        if setOnTop { verticalStackWithAlertLabel.insertArrangedSubview(alertLabel, at: 0) }
        else { verticalStackWithAlertLabel.addArrangedSubview(alertLabel) }
        alertLabel.text = text
    }
    
    func hideAlertLabel() {
        verticalStackWithAlertLabel.removeArrangedSubview(alertLabel)
        alertLabel.removeFromSuperview()
    }
    
    func addCustomView(view: UIView) {
        customView = view
        verticalStackWithAlertLabel.addArrangedSubview(customView)
    }
    
    private func setLabelText(title: String, instruction: String) {
        titleLabel.text = title
        instructionLabel.text = instruction
    }
    
    private func setStyleForView() {
        titleLabel.font = .systemFont(ofSize: 17.0, weight: .bold)
        titleLabel.textAlignment = .center
        
        instructionLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        
        alertLabel.font = .systemFont(ofSize: 12.0)
        alertLabel.textColor = .white
        alertLabel.backgroundColor = .red
        alertLabel.numberOfLines = 0
        alertLabel.lineBreakStrategy = .pushOut
        
        verticalStackWithAlertLabel.axis = .vertical
        verticalStackWithAlertLabel.contentMode = .center
        verticalStackWithAlertLabel.spacing = 14.0
    }
    
    private func setLayoutForView() {
        self.addSubview(titleLabel)
        self.addSubview(instructionLabel)
        self.addSubview(verticalStackWithAlertLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        verticalStackWithAlertLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            titleLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.0),
            instructionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            instructionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            
            verticalStackWithAlertLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 24.0),
            verticalStackWithAlertLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18.0),
            verticalStackWithAlertLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18.0),
        ])
    }
}
