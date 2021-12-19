//
//  EnterEmailViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/08.
//

import RxSwift
import RxGesture
import RxCocoa

class EnterEmailViewController: BaseSignUpViewController<EnterEmailView> {

    private enum EmailValidation {
        case valid
        case invalid
        
        // 페이스북 앱에서는 textField가 빈칸만 아니면 되지만 클론 앱에서는 정규식을 이용한 간단한 validation 추가
        init(isValid: Bool) {
            if isValid { self = .valid }
            else { self = .invalid }
        }
        
        func message() -> String {
            switch self {
            case .valid: return ""
            case .invalid: return "올바른 이메일 주소를 입력해주세요."
            }
        }
    }
    
    private let emailAddress = BehaviorRelay<String>(value: "")
    
    private var isValidEmail: EmailValidation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
    }
    
    private func bindView() {
        
        customView.emailTextField.rx.text.orEmpty
            .bind(to: emailAddress)
            .disposed(by: disposeBag)
        
        // email에 대한 validation
        customView.emailTextField.rx.text.orEmpty
            .map { [weak self] email -> Bool in
                return self?.isValid(email: email) ?? false }
            .bind { [weak self] isValid in
                self?.isValidEmail = EmailValidation.init(isValid: isValid)
            }.disposed(by: disposeBag)
        
        view.rx.tapGesture(configuration: { _, delegate in
            delegate.touchReceptionPolicy = .custom { _, shouldReceive in
                return !(shouldReceive.view is UIControl)
            }
        }).bind { [weak self] _ in
            guard let self = self else { return }
            if self.customView.emailTextField.isEditing {
                self.customView.emailTextField.endEditing(true)
            }
        }.disposed(by: disposeBag)
        
        customView.nextButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                guard let isValidEmail = self.isValidEmail else { return }

                self.customView.setAlertLabelText(as: isValidEmail.message())
                
                if isValidEmail == .valid {
                    self.push(viewController: SelectGenderViewController())
                    // TODO: email 전달
                }
        }.disposed(by: disposeBag)
    }
}

extension EnterEmailViewController {
    private func isValid(email: String) -> Bool {
        // "영어 대문자, 소문자 혹은 숫자 1개 이상"@"영어 소문자 1개 이상"."영어 소문자 2개 이상"
        let pattern = "^[A-Za-z0-9]+@[a-z]+\\.[a-z]{2,}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: email, range: NSRange(location: 0, length: email.count)) {
            return true
        }
        return false
    }
}
