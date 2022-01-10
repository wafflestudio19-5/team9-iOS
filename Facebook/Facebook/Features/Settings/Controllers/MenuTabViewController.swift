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
        
        tabView.kakaoDisconnectButton.rx.tapGesture().skip(1).bind { [weak self] _ in
            guard let self = self else { return }
            self.actionSheet(title: "카카오 계정 연결 끊기", message: "연결되어 있는 카카오 계정 연결을 끊으시겠습니까? 회원 정보는 그대로 유지되지만, 카카오 계정을 이용한 간편 로그인 기능을 이용하실 수 없습니다.", action: ("연결 끊기", destructive: true, action: self.disconnect))
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
    
    private func disconnect() {
        KakaoAuthManager.shared.requestKakaoLogin(type: .disconnect)
            .delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] success in
                switch success {
                case success: self?.alert(title: "성공", message: "카카오 계정 연결이 해제되었습니다.", action: "확인")
                default: self?.alert(title: "카카오 계정 오류", message: "요청 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                }
            }).disposed(by: disposeBag)
    }
}
