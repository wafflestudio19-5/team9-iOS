//
//  AddInformationView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/23.
//

import UIKit

class AddInformationView: UIView {

    let addInformationTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }
    
    private func configureTableView() {
        addInformationTableView.separatorStyle = .none
        addInformationTableView.register(UINib(nibName: "DetailProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailProfileCell")
        addInformationTableView.register(DateSelectTableViewCell.self, forCellReuseIdentifier: DateSelectTableViewCell.reuseIdentifier)
        addInformationTableView.allowsSelection = false
    }
}
