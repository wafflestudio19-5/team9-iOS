//
//  EditUsernameView.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/03.
//

import UIKit

class EditUsernameView: UIView {

    let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "이름 변경"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let lastnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "성"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let firstnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "이름(성은 제외)"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let lastnameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let firstnameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let alertView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let alertLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        let text = "알림: 일반적인 용법에 어긋나는 대소문자 표기, 구두점, 글자, 무작위 단어 등을 추가하지 마세요."
        let attributeText = NSMutableAttributedString(string: text)
        attributeText.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: (text as NSString).range(of: "알림"))
        label.attributedText = attributeText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "설정을 저장하려면 Facebook 비밀번호를 입력하세요"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.backgroundColor = .systemBlue
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray4
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        contentView.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 2),
            divider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        contentView.addSubview(lastnameLabel)
        NSLayoutConstraint.activate([
            lastnameLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            lastnameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        contentView.addSubview(lastnameTextField)
        NSLayoutConstraint.activate([
            lastnameTextField.heightAnchor.constraint(equalToConstant: 30),
            lastnameTextField.widthAnchor.constraint(equalToConstant: 200),
            lastnameTextField.topAnchor.constraint(equalTo: lastnameLabel.bottomAnchor),
            lastnameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        contentView.addSubview(firstnameLabel)
        NSLayoutConstraint.activate([
            firstnameLabel.topAnchor.constraint(equalTo: lastnameTextField.bottomAnchor),
            firstnameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        contentView.addSubview(firstnameTextField)
        NSLayoutConstraint.activate([
            firstnameTextField.heightAnchor.constraint(equalToConstant: 30),
            firstnameTextField.widthAnchor.constraint(equalToConstant: 200),
            firstnameTextField.topAnchor.constraint(equalTo: firstnameLabel.bottomAnchor),
            firstnameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        contentView.addSubview(alertView)
        NSLayoutConstraint.activate([
            alertView.topAnchor.constraint(equalTo: firstnameTextField.bottomAnchor, constant: 15),
            alertView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            alertView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        alertView.addSubview(alertLabel)
        NSLayoutConstraint.activate([
            alertLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
            alertLabel.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10),
            alertLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 10),
            alertLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10)
        ])
        
        contentView.addSubview(passwordLabel)
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 15),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        contentView.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.heightAnchor.constraint(equalToConstant: 30),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        contentView.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        contentView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 5),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }

}
