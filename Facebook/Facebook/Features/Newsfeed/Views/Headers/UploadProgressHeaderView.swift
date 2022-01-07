//
//  UploadProgressHeaderView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/01.
//

import Foundation
import UIKit


class UploadProgressHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let divider = Divider()
    
    var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = FacebookColor.blue.color()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    func displayProgress(progress: Progress?) {
        if let progress = progress {
            self.progressView.observedProgress = progress
        }
    }
    
    func setLayout() {
        self.addSubview(progressView)
        self.addSubview(divider)
        self.backgroundColor = .lightGray.withAlphaComponent(0.05)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 35),
            progressView.heightAnchor.constraint(equalToConstant: 5),
            progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .standardLeadingMargin),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .standardTrailingMargin),
            
            divider.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .standardTrailingMargin),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
