//
//  ProfileTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class ProfileTabViewController<View: ProfileTabView>: BaseViewController {

    override func loadView() { view = View() }
    
    private final var profile: ProfileTabView { return view as! View }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setNavigationBarItems(withEditButton: true)
    }
    


}
