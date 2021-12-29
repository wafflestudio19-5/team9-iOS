//
//  BaseSignUpViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import RxSwift

class BaseSignUpViewController<View: UIView>: UIViewController {

    let disposeBag = DisposeBag()
    
    var newUser = NewUser()
    
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
    
    convenience init(newUser: NewUser) {
        print("convenience init called")
        self.init()
        self.overwriteUser(newUser: newUser)
    }
    
    func overwriteUser(newUser: NewUser) {
        self.newUser = newUser
    }
}
