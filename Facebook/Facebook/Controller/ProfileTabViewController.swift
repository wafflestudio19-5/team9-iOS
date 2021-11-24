//
//  ProfileTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class ProfileTabViewController<View: ProfileTabView>: BaseViewController {

    override func loadView() { view = View() }
    
    private final var profile: ProfileTabView {
        guard let view = view as? View else {
            return ProfileTabView()
        }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setNavigationBarItems(withEditButton: true)
    }
    


}
