//
//  EnterUsernameViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/06.
//

import RxSwift
import RxGesture
import RxCocoa

class EnterUsernameViewController: BaseSignUpViewController<EnterUsernameView> {

    private enum Validation {
        case emptyFirstName
        case emptyLastName
        case emptyBoth
        case valid
        
        func message() -> String {
            switch self {
            case .emptyFirstName: return "성을 입력하세요"
            case .emptyLastName: return "이름을 입력하세요"
            case .emptyBoth: return "이름이 무엇인가요?"
            case .valid: return ""
            }
        }
    }
    
    private let firstName = BehaviorRelay<String>(value: "")
    private let lastName = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindView()
    }
    
    private func bindView() {
        
        customView.firstNameTextField.rx.text.orEmpty
            .bind(to: firstName)
            .disposed(by: disposeBag)
        
        customView.lastNameTextField.rx.text.orEmpty
            .bind(to: lastName)
            .disposed(by: disposeBag)
        
        view.rx.tapGesture(configuration: { _, delegate in
            delegate.touchReceptionPolicy = .custom { _, shouldReceive in
                return !(shouldReceive.view is UIControl)
            }
        }).bind { [weak self] _ in
            guard let self = self else { return }
            if self.customView.firstNameTextField.isEditing {
                self.customView.firstNameTextField.endEditing(true)
            } else if self.customView.lastNameTextField.isEditing {
                self.customView.lastNameTextField.endEditing(true)
            }
        }.disposed(by: disposeBag)

        customView.nextButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                
                let isFirstNameEmpty = self.firstName.value.isEmpty
                let isLastNameEmpty = self.lastName.value.isEmpty

                if !isFirstNameEmpty && !isLastNameEmpty {
                    self.customView.setAlertLabelText(as: Validation.valid.message())

                    self.newUser.first_name = self.firstName.value
                    self.newUser.last_name = self.lastName.value
                    
                    self.push(viewController: EnterBirthdateViewController(newUser: self.newUser))
                } else {
                    self.customView.setAlertLabelText(as: isFirstNameEmpty && isLastNameEmpty ? Validation.emptyBoth.message()
                                                           : (isFirstNameEmpty ? Validation.emptyFirstName.message() : Validation.emptyLastName.message()))
                }
            }.disposed(by: disposeBag)
    }
}
