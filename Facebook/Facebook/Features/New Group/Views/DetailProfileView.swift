//
//  DetailProfileView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/14.
//

import UIKit

class DetailProfileView: UIView {

    let detailProfileTableView = UITableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(detailProfileTableView)
        
        detailProfileTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailProfileTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            detailProfileTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            detailProfileTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            detailProfileTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureTableView() {
        detailProfileTableView.separatorStyle = .none  
        detailProfileTableView.register(UINib(nibName: "DetailProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailProfileCell")
        detailProfileTableView.allowsSelection = false
    }
}
