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
        
        self.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 35),
            searchBar.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .lightGray
        searchBar.setImage(UIImage(named: "icSearchNonW"), for: UISearchBar.Icon.search, state: .normal)
        searchBar.setImage(UIImage(named: "icCancel"), for: .clear, state: .normal)
        searchBar.placeholder = "직장 선택"
        searchBar.searchTextField.backgroundColor = UIColor.clear
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 18)
        
        return searchBar
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .lightGray
        return divider
    }()
}
