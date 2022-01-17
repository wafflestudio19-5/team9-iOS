//
//  MenuTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/10.
//

import UIKit
import RxSwift
import RxGesture
import RxCocoa

class MenuTabViewController: BaseTabViewController<MenuTabView> {

    private let isTryingLogout = BehaviorRelay(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tabView.largeTitleLabel)
        bind()
    }
    
    private func bind() {
        tabView.logoutButton.rx.tapGesture().skip(1).bind { [weak self] _ in
            guard let self = self else { return }
            self.actionSheet(title: "로그아웃하시겠어요?", action: ("로그아웃", destructive: true, action: self.logout))
        }.disposed(by: disposeBag)
        
        isTryingLogout.bind { [weak self] result in
            guard let self = self else { return }
            if result {
                self.tabView.alertSpinner.startSpinner(viewController: self)
            } else {
                self.tabView.alertSpinner.stopSpinner()
            }
        }.disposed(by: disposeBag)
    }
}

extension MenuTabViewController {
    private func logout() {
        isTryingLogout.accept(true)
        AuthManager.logout()
            .delay(RxTimeInterval.milliseconds(1200), scheduler: MainScheduler.instance)
            .subscribe { [weak self] success in
                guard let self = self else { return }
                self.isTryingLogout.accept(false)
                switch success {
                case .success(true):
                    UserDefaults.standard.setValue(false, forKey: "didLogin")
                    self.changeRootViewController(to: LoginViewController(), wrap: true)
                default:
                    self.alert(title: "로그아웃 오류", message: "요청 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                }
            }.disposed(by: disposeBag)
    }
}
