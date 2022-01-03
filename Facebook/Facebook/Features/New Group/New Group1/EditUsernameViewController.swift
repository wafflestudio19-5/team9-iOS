//
//  EditUsernameViewController.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa

class EditUsernameViewController<View: EditUsernameView>: UIViewController {

    override func loadView() {
        view = View()
    }
    
    var editUserProfileView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindButton()
    }
    
    func bindButton() {
        
    }
}

