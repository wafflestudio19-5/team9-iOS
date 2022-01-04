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
            
        ])
    }
    
    private func configureTableView() {
        
    }
    
}
