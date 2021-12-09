//
//  EnterPasswordViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import RxSwift
import RxGesture

class EnterPasswordViewController: BaseSignUpViewController<EnterPasswordView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
    }
    
    private func bindView() {
        
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
        
        customView.nextButton.rx.tap.bind {
            let rootTabBarController = RootTabBarController()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.changeRootViewController(rootTabBarController)
        }.disposed(by: disposeBag)
    }
}
