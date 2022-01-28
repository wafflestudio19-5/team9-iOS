//
//  BaseSignUpView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/03.
//

import UIKit
import SnapKit

class BaseSignUpView: UIView {
    
    private let titleLabel = UILabel()
    private let instructionLabel = UILabel()
    
    let alertLabel = LabelWithPadding(padding: UIEdgeInsets(top: 10.0, left: 7.0, bottom: 10.0, right: 7.0))
    let verticalStackWithAlertLabel = UIStackView()
    
    lazy var alertSpinner = AlertWithSpinner(message: "")
    
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
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.right.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        verticalStackWithAlertLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(24)
            make.left.right.equalTo(self.safeAreaLayoutGuide).inset(18)
        }
    }
}
