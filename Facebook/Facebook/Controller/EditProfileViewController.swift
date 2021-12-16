//
//  EditProfileViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/14.
//

import UIKit

class EditProfileViewController<View: EditProfileView>: UIViewController {

    override func loadView() {
        view = View()
    }
    
    var editProfileView: View {
        guard let view = view as? View else { return View() }
        return view
    }

    var tableView: UITableView {
        editProfileView.editProfileTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "프로필 편집"
        bindTableView()
    }
    
    func bindTableView(){
        
    }
}
