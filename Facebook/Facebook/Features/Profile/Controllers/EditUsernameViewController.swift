//
//  EditUsernameViewController.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/03.
//

import UIKit
import RxSwift
import RxGesture
import RxCocoa

class EditUsernameViewController<View: EditUsernameView>: UIViewController {

    override func loadView() {
        view = View()
    }
    
    var editUserProfileView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    let disposeBag = DisposeBag()
    
    private enum Validation {
        case emptyFirstName
        case emptyLastName
        case emptyBoth
        case passwordError
        case valid
        
        func message() -> String {
            switch self {
            case .emptyFirstName: return "성을 입력하세요"
            case .emptyLastName: return "이름을 입력하세요"
            case .emptyBoth: return "이름이 무엇인가요?"
            case .passwordError: return "잘못된 비밀번호를 입력하셨습니다."
            case .valid: return ""
            }
        }
    }
    
    private let firstName = BehaviorRelay<String>(value: "")
    private let lastName = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "이름 변경"
        bindButton()
    }
    
    func bindButton() {
        editUserProfileView.firstNameTextField.rx.text.orEmpty
            .bind(to: firstName)
            .disposed(by: disposeBag)
        
        editUserProfileView.lastNameTextField.rx.text.orEmpty
            .bind(to: lastName)
            .disposed(by: disposeBag)
        
        view.rx.tapGesture(configuration: { _, delegate in
            delegate.touchReceptionPolicy = .custom { _, shouldReceive in
                return !(shouldReceive.view is UIControl)
            }
        }).bind { [weak self] _ in
            guard let self = self else { return }
            if self.editUserProfileView.firstNameTextField.isEditing {
                self.editUserProfileView.firstNameTextField.endEditing(true)
            } else if self.editUserProfileView.lastNameTextField.isEditing {
                self.editUserProfileView.lastNameTextField.endEditing(true)
            } else if self.editUserProfileView.passwordTextField.isEditing {
                self.editUserProfileView.passwordTextField.endEditing(true)
            }
        }.disposed(by: disposeBag)
        
        editUserProfileView.saveButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                
                let isFirstNameEmpty = self.firstName.value.isEmpty
                let isLastNameEmpty = self.lastName.value.isEmpty

                if !isFirstNameEmpty && !isLastNameEmpty {
                    if let password = self.editUserProfileView.passwordTextField.text {
                        NetworkService.post(endpoint: .login(email: StateManager.of.user.profile.email, password: password), as: AuthResponse.self)
                            .subscribe(onNext: { [weak self] _ in
                                self?.saveName()
                            }, onError: { [weak self] _ in
                                self?.editUserProfileView.setAlertLabelText(as: Validation.passwordError.message())
                            })
                            .disposed(by: self.disposeBag)
                    }
                } else {
                    self.editUserProfileView.setAlertLabelText(as: isFirstNameEmpty && isLastNameEmpty ? Validation.emptyBoth.message()
                                                           : (isFirstNameEmpty ? Validation.emptyFirstName.message() : Validation.emptyLastName.message()))
                }
            }.disposed(by: disposeBag)
        
        editUserProfileView.cancelButton.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func saveName() {
        self.editUserProfileView.setAlertLabelText(as: Validation.valid.message())
        
        let updateData = ["first_name": self.firstName.value,
                          "last_name": self.lastName.value]

        NetworkService
            .update(endpoint: .profile(id: UserDefaultsManager.cachedUser?.id ?? 0, updateData: updateData))
            .subscribe { event in
                let request = event.element
            
                request?.responseDecodable(of: UserProfile.self) { dataResponse in
                    guard let userProfile = dataResponse.value else { return }
                    StateManager.of.user.profileDataSource.accept(userProfile)
                    self.navigationController?.popViewController(animated: true)
                }
            }.disposed(by: self.disposeBag)
    }
}

