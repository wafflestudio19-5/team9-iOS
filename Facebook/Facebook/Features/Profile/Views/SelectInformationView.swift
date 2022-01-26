//
//  SelectInformationView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/24.
//

import UIKit

class SelectInformationView: UIView {
    
    let selectInformationTableView = UITableView()
    let searchHeaderView = SearchHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setLayoutForView() {
        self.addSubview(selectInformationTableView)
        
        selectInformationTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectInformationTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            selectInformationTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            selectInformationTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            selectInformationTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureTableView() {
        selectInformationTableView.tableHeaderView = searchHeaderView
        searchHeaderView.widthAnchor.constraint(equalTo: selectInformationTableView.widthAnchor).isActive = true
        selectInformationTableView.separatorStyle = .none
        selectInformationTableView.register(SimpleInformationTableViewCell.self, forCellReuseIdentifier: SimpleInformationTableViewCell.reuseIdentifier)
        selectInformationTableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.reuseIdentifier)
    }

}
