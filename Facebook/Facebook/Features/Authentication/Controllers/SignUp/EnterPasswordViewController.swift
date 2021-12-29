//
//  EnterPasswordViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import RxSwift
import RxGesture
import RxCocoa
import Darwin

class EnterPasswordViewController: BaseSignUpViewController<EnterPasswordView> {
    
    private enum PasswordValidation {
        case valid
        case lessThanSixLetters
        case emptyLetters
        case invalidLetters
        
        func message() -> String {
            switch self {
            case .valid: return ""
            case .lessThanSixLetters: return "비밀번호는 6자 이상이어야 합니다. 다시 입력해 주세요."
            case .emptyLetters, .invalidLetters: return "숫자, 영문, 특수기호(!, & 등)를 조합한 여섯 자리 이상의 비밀번호를 입력하세요."
            }
        }
    }
    
    private let password = BehaviorRelay<String>(value: "")
    
    private var isValidPassword: PasswordValidation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
    }
    
    private func bindView() {
        
        customView.passwordTextField.rx.text.orEmpty
            .bind(to: password)
            .disposed(by: disposeBag)
        
        customView.passwordTextField.rx.text.orEmpty
            .map { [weak self] password -> PasswordValidation in
                return self?.isValid(password: password) ?? .emptyLetters }
            .bind { [weak self] isValid in
                self?.isValidPassword = isValid
            }.disposed(by: disposeBag)
        
        view.rx.tapGesture(configuration: { _, delegate in
            delegate.touchReceptionPolicy = .custom { _, shouldReceive in
                return !(shouldReceive.view is UIControl)
            }
        }).bind { [weak self] _ in
            guard let self = self else { return }
            if self.customView.passwordTextField.isEditing {
                self.customView.passwordTextField.endEditing(true)
            }
        }.disposed(by: disposeBag)
        
        customView.nextButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                guard let isValidPassword = self.isValidPassword else { return }
                
                self.customView.setAlertLabelText(as: isValidPassword.message())
                
                if isValidPassword == .valid {
                    self.newUser.password = self.password.value
                    self.registerUser()
                }
        }.disposed(by: disposeBag)
    }
}

extension EnterPasswordViewController {
    private func isValid(password: String) -> PasswordValidation {
        // "숫자, 영문, 특수기호(!, & 등)를 포함한 여섯 자리 이상"
        if password.isEmpty { return PasswordValidation.emptyLetters }
        else if password.count < 6 { return PasswordValidation.lessThanSixLetters }
        else {
            let pattern = "^[A-Za-z0-9!&]*$"
            let regex = try? NSRegularExpression(pattern: pattern)
            if let _ = regex?.firstMatch(in: password, range: NSRange(location: 0, length: password.count)) {
                return PasswordValidation.valid
            }
            return PasswordValidation.invalidLetters
        }
    }
    
    private func registerUser() {
        NetworkService.post(endpoint: .createUser(newUser: newUser), as: SignUpResponse.self)
            .subscribe { event in
                if event.isCompleted {
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.changeRootViewController(RootTabBarController())
                    }
                    return
                }
                
                guard (event.element?.1) != nil else {
                    print("회원가입 오류")
                    print(event)
                    return
                }
            }
            .disposed(by: disposeBag)
    }
}
