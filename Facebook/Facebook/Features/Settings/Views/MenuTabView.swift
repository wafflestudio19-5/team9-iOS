//
//  MenuTabView.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/10.
//

import UIKit
import SnapKit

class MenuTabView: UIView {
    
    let largeTitleLabel = UILabel()
    
    let logoutButton = RectangularSlimButton(title: "로그아웃", titleColor: .black, backgroundColor: UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0))
    
    let kakaoDisconnectButton = RectangularSlimButton(title: "카카오 계정 연결 끊기", titleColor: .black, backgroundColor: .systemYellow)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView() {
        largeTitleLabel.text = "메뉴"
        largeTitleLabel.font = .systemFont(ofSize: 24.0, weight: .semibold)
        largeTitleLabel.textColor = .label
    }
    
    private func setLayoutForView() {
        self.addSubview(logoutButton)
        self.addSubview(kakaoDisconnectButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        kakaoDisconnectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            logoutButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            logoutButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            
            kakaoDisconnectButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 10.0),
            kakaoDisconnectButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            kakaoDisconnectButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
    }
}
