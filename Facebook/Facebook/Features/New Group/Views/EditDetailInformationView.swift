//
//  EditDetailInformationView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/23.
//

import UIKit

class EditDetailInformationView: UIView {

    let editDetailInformationTableView = UITableView()
    let headerView = HeaderView()
    let footerView = FooterView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutforView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutforView() {
        self.addSubview(editDetailInformationTableView)
        self.addSubview(footerView)
        
        editDetailInformationTableView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            footerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            editDetailInformationTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            editDetailInformationTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            editDetailInformationTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            editDetailInformationTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureTableView() {
        //editDetailInformationTableView.tableHeaderView = headerView
        
        //headerView.widthAnchor.constraint(equalTo: editDetailInformationTableView.widthAnchor).isActive = true
        
        editDetailInformationTableView.separatorStyle = .none
        editDetailInformationTableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier)
        editDetailInformationTableView.register(DetailInformationTableViewCell.self, forCellReuseIdentifier: DetailInformationTableViewCell.reuseIdentifier)
        editDetailInformationTableView.allowsSelection = false
    }
}

