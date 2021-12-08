//
//  EnterEmailViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/08.
//

import RxSwift
import RxGesture

class EnterEmailViewController<View: EnterEmailView>: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = View()
    }
    
    private var enterEmailView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Facebook 가입하기"
        self.navigationItem.backButtonTitle = ""
        
        bindView()
    }
    
    private func bindView() {
        
        view.rx.tapGesture(configuration: { _, delegate in
            delegate.touchReceptionPolicy = .custom { _, shouldReceive in
                return !(shouldReceive.view is UIControl)
            }
        }).bind { [weak self] _ in
            guard let self = self else { return }
            if self.enterEmailView.emailTextField.isEditing {
                self.enterEmailView.emailTextField.endEditing(true)
            }
        }.disposed(by: disposeBag)
        
        enterEmailView.nextButton.rx.tap.bind {
            // navigate to selectGenderView
        }.disposed(by: disposeBag)
    }
}
