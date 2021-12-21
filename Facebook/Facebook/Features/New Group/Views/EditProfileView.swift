//
//  EditProfileView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/14.
//

import UIKit

class EditProfileView: UIView {

    let editProfileTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        setStyleForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(editProfileTableView)
        
        editProfileTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editProfileTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            editProfileTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            editProfileTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            editProfileTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func setStyleForView() {
        //profileTableView.tableHeaderView = UIView()  // removes the separator at the top
        editProfileTableView.register(UINib(nibName: "ProfileImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileImageCell")
        editProfileTableView.register(UINib(nibName: "DetailProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailProfileCell")
        editProfileTableView.allowsSelection = false
    }
}
