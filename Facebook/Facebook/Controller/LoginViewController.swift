//
//  LoginViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import RxSwift
import RxGesture

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
            
        }.disposed(by: disposeBag)
        
        loginView.forgotPasswordButton.rx.tap.bind {
            
        }.disposed(by: disposeBag)
        
        loginView.backButton.rx.tap.bind {
            
        }.disposed(by: disposeBag)
        
        view.rx.tapGesture()
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
        
        loginView.idTextField.rx
            .controlEvent(.allTouchEvents)
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                print("idtextfield tapped")
            }.disposed(by: disposeBag)
    }
}
