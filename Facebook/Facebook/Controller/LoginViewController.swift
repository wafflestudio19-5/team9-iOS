//
//  LoginViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import RxSwift
import RxGesture
import RxKeyboard

class LoginViewController<View: LoginView>: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = View()
    }
    
    var loginView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    private func bindView() {
        loginView.loginButton.rx.tap.bind {
            print("login button tapped")
            // login validation
        }.disposed(by: disposeBag)
        
        loginView.forgotPasswordButton.rx.tap.bind {
            // navigate to findPasswordView
        }.disposed(by: disposeBag)
        
        loginView.backButton.rx.tap.bind {
            
        }.disposed(by: disposeBag)
        
        loginView.createAccountButton.rx.tap.bind {
            // navigate to createAccountView
        }.disposed(by: disposeBag)

        
        // textfield가 비어있지 않은가?에 대한 Bool형 event 방출
        let hasEnteredId = loginView.idTextField.rx.text.orEmpty.map { !$0.isEmpty }
        let hasEnteredPassword = loginView.passwordTextField.rx.text.orEmpty.map { !$0.isEmpty }
        
        // 두 개의 textfield가 모두 비어있지 않은가?에 대한 event 방출
        let hasEnteredBoth = Observable.combineLatest(hasEnteredId, hasEnteredPassword, resultSelector: { ($0 && $1) })
        
        // 두 개의 textfield가 비어있지 않을 경우에 loginButton 활성화
        hasEnteredBoth
            .bind(to: self.loginView.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 두 개의 textfield가 비어있지 않을 경우에는 loginButton label 흰색, 그렇지 않을 경우에는 회색
        hasEnteredBoth
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loginView.loginButton.changeLabelTextColor(to: {
                    return result ? UIColor.white : UIColor.systemGray3
                }())
            }).disposed(by: disposeBag)

        // Keyboard의 높이에 따라 "새 계정 만들기" 버튼 위치 조정
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                guard let bottomConstraint = self.loginView.bottomConstraint else { return }

                if keyboardVisibleHeight == 0 {
                    bottomConstraint.constant = -16.0
                } else {
                    let height = keyboardVisibleHeight - self.view.safeAreaInsets.bottom
                    print(height)
                    bottomConstraint.constant = -height - 16.0
                }
                self.loginView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        // view의 아무 곳이나 누르면 textfield 입력 상태 종료
        view.rx.tapGesture(configuration: { _, delegate in
            delegate.touchReceptionPolicy = .custom { _, shouldReceive in
                return !(shouldReceive.view is UIControl)
            }
        })
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.loginView.idTextField.isEditing {
                    self.loginView.idTextField.endEditing(true)
                    
                } else if self.loginView.passwordTextField.isEditing {
                    self.loginView.passwordTextField.endEditing(true)
                }
            })
            .disposed(by: disposeBag)
    }
}
