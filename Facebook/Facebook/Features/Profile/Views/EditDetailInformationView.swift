//
//  EditDetailInformationView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/23.
//

import UIKit

class EditDetailInformationView: UIView {

    let editDetailInformationTableView = UITableView(frame: .zero, style: .grouped)
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "회원님을 소개할 항목을 구성해보세요"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "선택하신 상세 정보는 전체 공개됩니다."
        label.textColor = .systemGray4
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        editDetailInformationTableView.backgroundColor = .white
        setLayoutforView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutforView() {
        self.addSubview(editDetailInformationTableView)
        
        editDetailInformationTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editDetailInformationTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            editDetailInformationTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            editDetailInformationTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            editDetailInformationTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        headerView.frame = CGRect(x: 0, y: 0, width: editDetailInformationTableView.frame.width, height: 70)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(subTitleLabel)
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 70),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            subTitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15)
        ])
    }
    
    private func configureTableView() {
        editDetailInformationTableView.tableHeaderView = headerView
        
        editDetailInformationTableView.separatorStyle = .none
        editDetailInformationTableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier)
        editDetailInformationTableView.register(DetailInformationTableViewCell.self, forCellReuseIdentifier: DetailInformationTableViewCell.reuseIdentifier)
        editDetailInformationTableView.allowsSelection = false
    }
}

