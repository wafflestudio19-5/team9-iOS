//
//  ActivateAccountViewController.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/27.
//

import UIKit
import RxSwift
import RxGesture
import RxCocoa

class ActivateAccountViewController<View: ActivateAccountView>: UIViewController {

    private let isProcessing = BehaviorRelay(value: false)
    private var workType: AuthManager.WorkType = .deletion
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = View()
    }
    
    var customView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "계정 확인"
        
        customView.setLabelText(with: UserDefaultsManager.cachedUser?.email ?? "")
        bind()
    }
    
    private func bind() {
        customView.verificationButton.rx.tap.bind { [weak self] _ in
            self?.checkAccountStatus()
        }.disposed(by: disposeBag)
        
        customView.logoutButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            self.actionSheet(title: "로그아웃하시겠어요?", action: ("로그아웃", destructive: true, action: self.logout))
        }.disposed(by: disposeBag)
        
        customView.deleteAccountButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            self.actionSheet(title: "회원탈퇴", message: "Facebook에 저장된 모든 회원 정보를 삭제합니다. 계속하시겠습니까?", action: ("회원탈퇴", destructive: true, action: self.deleteAccount))
        }.disposed(by: disposeBag)
        
        isProcessing.bind { [weak self] processing in
            guard let self = self else { return }
            if processing {
                self.customView.activateAlertSpinner(workType: self.workType, at: self)
            } else {
                self.customView.alertSpinner.stop()
            }
        }.disposed(by: disposeBag)
    }
}

extension ActivateAccountViewController {
    private func checkAccountStatus() {
        AuthManager.check()
            .subscribe { [weak self] success in
                switch success {
                case .success(true):
                    UserDefaultsManager.isLoggedIn = true
                    self?.changeRootViewController(to: RootTabBarController())
                default: self?.alert(title: "활성화되지 않음", message: "계정이 활성화되지 않았습니다. 이메일을 확인해주세요.", action: "확인")
                }
            }.disposed(by: disposeBag)
    }
    
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
