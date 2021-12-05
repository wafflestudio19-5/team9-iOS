//
//  EnterUsernameViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/06.
//

import RxSwift

class EnterUsernameViewController<View: EnterUsernameView>: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = View()
    }
    
    var signUpView: View {
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
        
    }

}
