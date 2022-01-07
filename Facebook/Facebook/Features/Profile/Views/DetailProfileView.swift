//
//  DetailProfileView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/14.
//

import UIKit

class DetailProfileView: UIView {

    let detailProfileTableView = ResponsiveTableView(frame: .zero, style: .grouped)
    let refreshControl = UIRefreshControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
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
        detailProfileTableView.tableHeaderView = UIView(frame: .zero)
        detailProfileTableView.separatorStyle = .none  
        detailProfileTableView.register(SimpleInformationTableViewCell.self, forCellReuseIdentifier: SimpleInformationTableViewCell.reuseIdentifier)
        detailProfileTableView.register(DetailInformationTableViewCell.self, forCellReuseIdentifier: DetailInformationTableViewCell.reuseIdentifier)
        detailProfileTableView.allowsSelection = false
        detailProfileTableView.refreshControl = refreshControl
    }
    
    private lazy var bottomSpinner: UIView = {
        let view = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: self.frame.size.width,
            height: 100)
        )
        let spinner = UIActivityIndicatorView()
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.startAnimating()
        return view
    }()
    
    func showBottomSpinner() {
        self.detailProfileTableView.tableFooterView = self.bottomSpinner
    }
    
    func hideBottomSpinner() {
        self.detailProfileTableView.tableFooterView = UIView(frame: .zero)
    }
}
