//
//  BottomSpinner.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/05.
//

import UIKit

class BottomSpinner: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let spinner = UIActivityIndicatorView()
        self.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
