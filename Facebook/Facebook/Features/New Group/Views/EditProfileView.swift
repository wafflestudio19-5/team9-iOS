//
//  EditProfileView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/14.
//

import UIKit

class EditProfileView: UIView {

    let editProfileTableView = UITableView(frame: .zero, style: .grouped)
    
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
        editProfileTableView.separatorStyle = .none //cell과 cell사이 separator line 제거
        editProfileTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        editProfileTableView.register(UINib(nibName: "SelfIntroTableViewCell", bundle: nil), forCellReuseIdentifier: "SelfIntroCell")
        editProfileTableView.register(UINib(nibName: "DetailProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailProfileCell")
        editProfileTableView.register(UINib(nibName: "EditProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileCell")
        editProfileTableView.allowsSelection = false
    }
}
