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
    
    let logoutButton = RectangularSlimButton(title: "로그아웃", titleColor: .black, backgroundColor: .grayscales.button)
    
    let alertSpinner = AlertWithSpinner(message: "로그아웃 중입니다...")
    
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
        
        logoutButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
    }
}
