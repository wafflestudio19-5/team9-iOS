//
//  PhotoPopUpView.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/03.
//

import UIKit

class PhotoPopUpView: UIView {

    let photoPopUpTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .systemBlue
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayoutForView() {
        
        self.addSubview(photoPopUpTableView)
        photoPopUpTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoPopUpTableView.heightAnchor.constraint(equalToConstant: 300),
            photoPopUpTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            photoPopUpTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            photoPopUpTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureTableView() {
        photoPopUpTableView.register(SimpleInformationTableViewCell.self, forCellReuseIdentifier: SimpleInformationTableViewCell.reuseIdentifier)
        photoPopUpTableView.isScrollEnabled = false
    }
    
}
