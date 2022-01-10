//
//  MenuTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/10.
//

import UIKit
import RxSwift
import RxGesture

class MenuTabViewController: BaseTabViewController<MenuTabView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tabView.largeTitleLabel)
        bind()
    }
    
    private func bind() {
        tabView.logoutButton.rx.tapGesture().skip(1).bind { [weak self] _ in
            print("logout button tapped")
            self?.logout()
        }.disposed(by: disposeBag)
    }
}

extension MenuTabViewController {
    private func logout() {
        AuthManager.shared.logout()
            .subscribe { [weak self] success in
                switch success {
                case .success(true):
                    UserDefaults.standard.setValue(false, forKey: "didLogin")
                    self?.changeRootViewController(to: LoginViewController(), wrap: true)
                default: self?.alert(title: "로그아웃 오류", message: "요청 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                }
            }.disposed(by: disposeBag)
    }
}
