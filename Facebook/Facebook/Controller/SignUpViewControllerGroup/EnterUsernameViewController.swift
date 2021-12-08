//
//  EnterUsernameViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/06.
//

import RxSwift
import RxGesture

class EnterUsernameViewController: BaseSignUpViewController<EnterUsernameView> {

    override func viewDidLoad() {
        super.viewDidLoad()

        bindView()
    }
    
    private func bindView() {
        customView.nextButton.rx.tap.bind {
            let enterBirthdateViewController = EnterBirthdateViewController()
            self.navigationController?.pushViewController(enterBirthdateViewController, animated: true)
        }.disposed(by: disposeBag)
    }

}
