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
    
    var userProfile: UserProfile?
    
    private let firstName = BehaviorRelay<String>(value: "")
    private let lastName = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "이름 변경"
        loadData()
        bindButton()
    }
    
    func loadData() {
        NetworkService.get(endpoint: .profile(id: 41), as: UserProfile.self)
            .subscribe { [weak self] event in
                guard let self = self else { return }
            
                if event.isCompleted {
                    return
                }
            
                guard let response = event.element?.1 else {
                    print("데이터 로드 중 오류 발생")
                    print(event)
                    return
                }
            
                self.userProfile = response
        }.disposed(by: disposeBag)
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
            }
        }.disposed(by: disposeBag)
        
        editUserProfileView.saveButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                
                let isFirstNameEmpty = self.firstName.value.isEmpty
                let isLastNameEmpty = self.lastName.value.isEmpty

                if !isFirstNameEmpty && !isLastNameEmpty {
                    self.editUserProfileView.setAlertLabelText(as: Validation.valid.message())
                    
                    let updateData = ["first_name": self.firstName.value,
                                      "last_name": self.lastName.value]

                    NetworkService
                        .update(endpoint: .profile(id: 41, updateData: updateData))
                        .subscribe { [weak self] _ in
                            self?.navigationController?.popViewController(animated: true)
                        }.disposed(by: self.disposeBag)
                } else {
                    self.editUserProfileView.setAlertLabelText(as: isFirstNameEmpty && isLastNameEmpty ? Validation.emptyBoth.message()
                                                           : (isFirstNameEmpty ? Validation.emptyFirstName.message() : Validation.emptyLastName.message()))
                }
            }.disposed(by: disposeBag)
        
        editUserProfileView.cancelButton.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}

