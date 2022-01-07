//
//  EditUserProfileView.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/02.
//

import UIKit

class EditUserProfileView: UIView {

    let editUserProfileTableView = UITableView()
    
    let headerStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        stackView.backgroundColor = .systemGray4
        
        return stackView
    }()
    
    let alertLabel: LabelWithPadding = {
        let label = LabelWithPadding(padding: UIEdgeInsets(top: 10.0, left: 7.0, bottom: 10.0, right: 7.0))
        label.backgroundColor = .systemRed
        label.textColor = .white
        
        return label
    }()
    
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 1
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.cornerRadius = 1
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAlertLabelText(as text: String) {
        if !text.isEmpty { showAlertLabel(as: text) }
        else { hideAlertLabel() }
    }
    
    func showAlertLabel(as text: String) {
        headerStackView.addArrangedSubview(alertLabel)
        alertLabel.text = text
    }
    
    func hideAlertLabel() {
        headerStackView.removeArrangedSubview(alertLabel)
        alertLabel.removeFromSuperview()
    }
    
    private func setLayoutForView() {
        self.addSubview(editUserProfileTableView)
        editUserProfileTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editUserProfileTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            editUserProfileTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            editUserProfileTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            editUserProfileTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        footerView.frame = CGRect(x: 0, y: 0, width: editUserProfileTableView.frame.width, height: 50)
        
        footerView.addSubview(saveButton)
        footerView.addSubview(cancelButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            footerView.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.widthAnchor.constraint(equalToConstant: 35),
            cancelButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -10),
            saveButton.widthAnchor.constraint(equalToConstant: 35),
            saveButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -10)
        ])
    }

    private func configureTableView() {
        editUserProfileTableView.tableHeaderView = headerStackView
        editUserProfileTableView.tableFooterView = footerView
        editUserProfileTableView.backgroundColor = .systemGray4
        editUserProfileTableView.register(BirthSelectTableViewCell.self, forCellReuseIdentifier: BirthSelectTableViewCell.reuseIdentifier)
        editUserProfileTableView.register(EditUsernameTableViewCell.self, forCellReuseIdentifier: EditUsernameTableViewCell.reuseIdentifier)
        editUserProfileTableView.register(GenderSelectTableViewCell.self, forCellReuseIdentifier: GenderSelectTableViewCell.reuseIdentifier)
        editUserProfileTableView.allowsSelection = false
    }
}
