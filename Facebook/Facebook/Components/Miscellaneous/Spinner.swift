//
//  BottomSpinner.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/05.
//

import UIKit
import SnapKit

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

/// 짧은 안내 메시지를 위한 spinner + 메시지 형태의 alert입니다
struct AlertWithSpinner {
    
    private let alert: UIAlertController
    private let spinner = UIActivityIndicatorView()
    
    var message: String
    
    init(message: String) {
        self.message = message
        alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .alert)
        spinner.style = .medium
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        alert.view.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.centerY.equalTo(alert.view)
            make.leading.equalTo(alert.view.safeAreaLayoutGuide).inset(25)
        }
    }
    
    func start(viewController: UIViewController, message: String = "") {
        if !message.isEmpty { self.alert.message = message }
        viewController.present(self.alert, animated: true)
        spinner.startAnimating()
    }
    
    func stop() {
        spinner.stopAnimating()
        alert.dismiss(animated: true)
    }
}
