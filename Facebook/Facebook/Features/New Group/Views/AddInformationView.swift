//
//  AddInformationView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/23.
//

import UIKit

class AddInformationView: UIView {

    let addInformationTableView = UITableView(frame: .zero, style: .grouped)
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray6
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(addInformationTableView)
        addInformationTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addInformationTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            addInformationTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            addInformationTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            addInformationTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        footerView.frame = CGRect(x: 0, y: 0, width: addInformationTableView.frame.width, height: 50)
        
        footerView.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
            saveButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -10),
            saveButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -10)
        ])
        
        self.addSubview(footerView)
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        addInformationTableView.tableHeaderView = UIView(frame: .zero)
        addInformationTableView.separatorStyle = .singleLine
        addInformationTableView.register(SimpleInformationTableViewCell.self, forCellReuseIdentifier: SimpleInformationTableViewCell.reuseIdentifier)
        addInformationTableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.reuseIdentifier)
        addInformationTableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: TextViewTableViewCell.reuseIdentifier)
        addInformationTableView.register(DateSelectTableViewCell.self, forCellReuseIdentifier: DateSelectTableViewCell.reuseIdentifier)
        addInformationTableView.allowsSelection = false
    }
}
