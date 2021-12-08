//
//  EnterEmailViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/08.
//

import RxSwift
import RxGesture

class EnterEmailViewController: BaseSignUpViewController<EnterEmailView> {

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
            if self.customView.emailTextField.isEditing {
                self.customView.emailTextField.endEditing(true)
            }
        }.disposed(by: disposeBag)
        
        customView.nextButton.rx.tap.bind {
            // navigate to selectGenderView
        }.disposed(by: disposeBag)
    }
}
