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
    
    let logoutButton = RectangularSlimButton(title: "로그아웃", titleColor: .black, backgroundColor: .grayscales.button, highlightColor: .systemGray3)
    
    let alertSpinner = AlertWithSpinner(message: "")
    
    let kakaoConnectButton = RectangularSlimButton(title: "카카오 계정 연결하기", titleColor: .black, backgroundColor: .grayscales.button, highlightColor: .systemGray3)
    let kakaoDisconnectButton = RectangularSlimButton(title: "카카오 계정 연결 끊기", titleColor: .black, backgroundColor: .grayscales.button, highlightColor: .systemGray3)
    
    let deleteAccountButton = RectangularSlimButton(title: "회원 탈퇴", titleColor: .red, backgroundColor: .white, highlightColor: .systemGray6)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateAlertSpinner(workType: AuthManager.WorkType, at viewController: UIViewController) {
        alertSpinner.start(viewController: viewController, message: workType.getMessage())
    }
    
    private func setStyleForView() {
        largeTitleLabel.text = "메뉴"
        largeTitleLabel.font = .systemFont(ofSize: 24.0, weight: .semibold)
        largeTitleLabel.textColor = .label
    }
    
    private func setLayoutForView() {
        self.addSubview(logoutButton)
        self.addSubview(kakaoDisconnectButton)
        self.addSubview(kakaoConnectButton)
        self.addSubview(deleteAccountButton)
        
        logoutButton.snp.makeConstraints { make in
            make.top.left.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16.0).priority(999)
        }
        
        kakaoDisconnectButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(10.0)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16.0)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16.0).priority(999)
        }
        
        kakaoConnectButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoDisconnectButton.snp.bottom).offset(10.0)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16.0)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16.0).priority(999)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16.0)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(16.0)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-16.0).priority(999)
        }
    }
}
