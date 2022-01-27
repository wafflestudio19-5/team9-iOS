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

    private let isProcessing = BehaviorRelay(value: false)
    private var workType: AuthManager.WorkType = .deletion
    
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
        
        tabView.kakaoDisconnectButton.rx.tapGesture().skip(1).bind { [weak self] _ in
            guard let self = self else { return }
            self.actionSheet(title: "카카오 계정 연결 끊기", message: "연결되어 있는 카카오 계정 연결을 끊으시겠습니까? 회원 정보는 그대로 유지되지만, 카카오 계정을 이용한 간편 로그인 기능을 이용하실 수 없습니다.", action: ("연결 끊기", destructive: true, action: self.disconnect))
        }.disposed(by: disposeBag)
        
        isProcessing.bind { [weak self] processing in
            guard let self = self else { return }
            if processing {
                self.tabView.activateAlertSpinner(workType: self.workType, at: self)
            } else {
                self.tabView.alertSpinner.stop()
            }
        }.disposed(by: disposeBag)
        
        tabView.kakaoDisconnectButton.rx.tapGesture().skip(1).bind { [weak self] _ in
            guard let self = self else { return }
            self.actionSheet(title: "카카오 계정 연결 끊기", message: "연결되어 있는 카카오 계정 연결을 끊으시겠습니까? 회원 정보는 그대로 유지되지만, 카카오 계정을 이용한 간편 로그인 기능을 이용하실 수 없습니다.", action: ("연결 끊기", destructive: true, action: self.disconnect))
        }.disposed(by: disposeBag)
        
        tabView.kakaoConnectButton.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.connect()
            }.disposed(by: disposeBag)
        
        tabView.deleteAccountButton.rx.tapGesture().skip(1).bind { [weak self] _ in
            guard let self = self else { return }
            self.actionSheet(title: "회원탈퇴", message: "Facebook에 저장된 모든 회원 정보를 삭제합니다. 계속하시겠습니까?", action: ("회원탈퇴", destructive: true, action: self.deleteAccount))
        }.disposed(by: disposeBag)
    }
}

extension MenuTabViewController {
    private func logout() {
        workType = .logout
        isProcessing.accept(true)
        AuthManager.logout()
            .delay(RxTimeInterval.milliseconds(1200), scheduler: MainScheduler.instance)
            .subscribe { [weak self] success in
                guard let self = self else { return }
                self.isProcessing.accept(false)
                switch success {
                case .success(true):
                    UserDefaultsManager.isLoggedIn = false
                    self.changeRootViewController(to: LoginViewController(), wrap: true)
                default:
                    self.alert(title: "로그아웃 오류", message: "요청 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                }
            }.disposed(by: disposeBag)
    }
    
    private func disconnect() {
        KakaoAuthManager.requestKakaoLogin(type: .disconnect)
            .delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] success in
                switch success {
                case true: self?.alert(title: "성공", message: "카카오 계정 연결이 해제되었습니다.", action: "확인")
                case false: self?.alert(title: "실패", message: "연결된 카카오 계정이 없습니다.", action: "확인")
                }
            }).disposed(by: disposeBag)
    }
    
    private func connect() {
        KakaoAuthManager.requestKakaoLogin(type: .connect)
            .subscribe (onNext: { [weak self] success in
                switch success {
                case true: self?.alert(title: "성공", message: "카카오 계정 연결이 완료되었습니다.", action: "확인")
                case false: self?.alert(title: "실패", message: "이미 연결된 계정입니다.", action: "확인")
                }
            }).disposed(by: disposeBag)
    }
    
    private func deleteAccount() {
        workType = .deletion
        isProcessing.accept(true)
        AuthManager.delete()
            .delay(RxTimeInterval.milliseconds(1200), scheduler: MainScheduler.instance)
            .subscribe { [weak self] success in
                guard let self = self else { return }
                self.isProcessing.accept(false)
                switch success {
                case .success(true):
                    UserDefaultsManager.isLoggedIn = false
                    self.changeRootViewController(to: LoginViewController(), wrap: true)
                default:
                    self.alert(title: "회원탈퇴 오류", message: "요청 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                }
            }.disposed(by: disposeBag)
    }
}
