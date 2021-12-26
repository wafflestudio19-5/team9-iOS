//
//  SearchHeader.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/24.
//

import Foundation
import UIKit
import RxSwift

class SearchHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(searchImage)
        NSLayoutConstraint.activate([
            searchImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchImage.widthAnchor.constraint(equalToConstant: 30),
            searchImage.heightAnchor.constraint(equalToConstant: 30),
            searchImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
        
        self.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 30),
            searchTextField.leadingAnchor.constraint(equalTo: searchImage.trailingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        self.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private lazy var searchImage: UIImageView = {
        let image = UIImage(systemName: "magnifyingglass")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .lightGray
        return divider
    }()
}
