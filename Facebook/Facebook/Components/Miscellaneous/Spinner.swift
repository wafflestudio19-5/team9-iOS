//
//  BottomSpinner.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/05.
//

import UIKit

class Spinner: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let spinner = UIActivityIndicatorView()
        self.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(self)
        }
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}