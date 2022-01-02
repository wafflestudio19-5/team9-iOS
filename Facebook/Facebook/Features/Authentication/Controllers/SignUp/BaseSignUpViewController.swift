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
        print("viewDidLoad called")
        self.navigationItem.title = "Facebook 가입하기"
        self.navigationItem.backButtonTitle = ""
    }

    func registerUser() {
        NetworkService.post(endpoint: .createUser(newUser: NewUser.shared), as: SignUpResponse.self)
            .subscribe { [weak self] event in
                
                // 회원가입 성공
                if event.isCompleted {
                    // currentUser 등록(이메일)
                    if let email = event.element?.1.user {
                        CurrentUser.shared.email = email
                    }
                    // 토큰 등록
                    if let token = event.element?.1.token {
                        NetworkService.registerToken(token: token)
                    }
                    
                    NewUser.shared.reset()
                    self?.changeRootViewController(to: RootTabBarController())
                    return
                }
                // 회원가입 실패
                if event.isStopEvent {
                    print(event)
                    return
                }
            }
            .disposed(by: disposeBag)
    }
}
