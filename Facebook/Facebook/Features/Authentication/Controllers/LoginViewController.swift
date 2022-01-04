//
//  LoginViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import RxSwift
import RxGesture
import RxCocoa
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
    
    private let email = BehaviorRelay<String>(value: "")
    private let password = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backButtonTitle = ""
        bindView()
    }
    
    private func bindView() {
        loginView.loginButton.rx.tap.bind { [weak self] _ in
            self?.login()
        }.disposed(by: disposeBag)
        
        loginView.forgotPasswordButton.rx.tap.bind {
            // navigate to findPasswordView
            // 사용X
        }.disposed(by: disposeBag)
        
        loginView.backButton.rx.tap.bind {
            // 사용X
        }.disposed(by: disposeBag)
        
        loginView.createAccountButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            self.push(viewController: EnterUsernameViewController())
        }.disposed(by: disposeBag)

        loginView.emailTextField.rx.text.orEmpty
            .bind(to: email)
            .disposed(by: disposeBag)
        
        loginView.passwordTextField.rx.text.orEmpty
            .bind(to: password)
            .disposed(by: disposeBag)
        
        // 두 개의 textfield가 모두 비어있지 않은가?에 대한 event 방출
        let hasEnteredBoth = Observable.combineLatest(email, password, resultSelector: { (!$0.isEmpty && !$1.isEmpty) })
        
        // 두 개의 textfield가 비어있지 않을 경우에 loginButton 활성화
        hasEnteredBoth
            .bind(to: self.loginView.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 두 개의 textfield가 비어있지 않을 경우에는 loginButton label 흰색, 그렇지 않을 경우에는 회색
        hasEnteredBoth
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loginView.loginButton.changeLabelTextColor(to: result ? .white : .systemGray3)
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
                    bottomConstraint.constant = -height - 16.0
                }
                self.loginView.layoutIfNeeded()
            }).disposed(by: disposeBag)
        
        // view의 아무 곳이나 누르면 textfield 입력 상태 종료
        view.rx.tapGesture(configuration: { _, delegate in
            delegate.touchReceptionPolicy = .custom { _, shouldReceive in
                return !(shouldReceive.view is UIControl)
            }
        }).bind { [weak self] _ in
            guard let self = self else { return }
            if self.loginView.emailTextField.isEditing {
                self.loginView.emailTextField.endEditing(true)
            } else if self.loginView.passwordTextField.isEditing {
                self.loginView.passwordTextField.endEditing(true)
            }
        }.disposed(by: disposeBag)
    }
}

extension LoginViewController {
    private func login() {
        AuthManager.login(email: self.email.value, password: self.password.value)
            .subscribe { [weak self] result in
                guard let success = result.element else { return }
                
                switch success {
                case true:
                    // 카카오 로그인 페이지로 이동
                    self?.changeRootViewController(to: RootTabBarController())
                case false:
                    self?.alert(title: "잘못된 이메일", message: "입력한 이메일이 계정에 포함된 이메일이 아닌 것 같습니다. 이메일 주소를 확인하고 다시 시도해주세요.", action: "확인")
                }
            }.disposed(by: disposeBag)
    }
}
