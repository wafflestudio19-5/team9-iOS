//
//  DatePopOverView.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/03.
//

import UIKit

class DatePopOverView: UIView {

    let datePopOverTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayoutForView() {
        self.addSubview(datePopOverTableView)
        
        datePopOverTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePopOverTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            datePopOverTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            datePopOverTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            datePopOverTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureTableView() {
        datePopOverTableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.reuseIdentifier)
    }

}
