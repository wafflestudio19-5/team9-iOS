//
//  BaseSignUpViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import RxSwift

class BaseSignUpViewController<View: UIView>: UIViewController {

    let disposeBag = DisposeBag()
    
    var customView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    override func loadView() { view = View() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Facebook 가입하기"
        self.navigationItem.backButtonTitle = ""
    }

    func registerUser() {
        AuthManager.signup(user: NewUser.shared)
            .subscribe { [weak self] result in
                guard let success = result.element else { return }
                
                switch success {
                case true:
                    // 카카오 로그인 페이지로 이동
                    self?.changeRootViewController(to: RootTabBarController())
                case false:
                    // 임의로 만들었습니다
                    self?.alert(title: "회원가입 실패", message: "이미 등록되어 있거나 가입할 수 없는 계정입니다. 입력하신 정보를 다시 확인해주시기 바랍니다.", action: "확인")
                }
            }.disposed(by: disposeBag)
    }
}
