//
//  Header&FooterView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/23.
//

import Foundation
import UIKit

class FooterView: UIView {
    let buttonLabel = "저장"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50)
    
        self.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(buttonLabel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        
        return button
    }()
}

