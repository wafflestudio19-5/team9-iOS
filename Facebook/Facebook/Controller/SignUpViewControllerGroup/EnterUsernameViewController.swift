//
//  EnterUsernameViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/06.
//

import RxSwift
import RxGesture

class EnterUsernameViewController<View: EnterUsernameView>: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = View()
    }
    
    private var enterUsernameView: View {
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
        enterUsernameView.nextButton.rx.tap.bind {
            let enterBirthdateViewController = EnterBirthdateViewController()
            self.navigationController?.pushViewController(enterBirthdateViewController, animated: false)
        }.disposed(by: disposeBag)
    }

}
