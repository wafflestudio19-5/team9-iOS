//
//  ActivateAccountViewController.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/27.
//

import UIKit
import RxSwift
import RxGesture

class ActivateAccountViewController<View: ActivateAccountView>: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = View()
    }
    
    var customView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "계정 확인"
        
        customView.setLabelText(with: UserDefaultsManager.cachedUser?.email ?? "")
        bind()
    }
    
    private func bind() {
        customView.verificationButton.rx.tap.bind { [weak self] _ in
            // active 유저인지 확인
            print(UserDefaultsManager.isValid)
        }.disposed(by: disposeBag)
        
        customView.returnButton.rx.tap.bind { [weak self] _ in
            self?.changeRootViewController(to: LoginViewController(), wrap: true)
        }.disposed(by: disposeBag)
    }
}
