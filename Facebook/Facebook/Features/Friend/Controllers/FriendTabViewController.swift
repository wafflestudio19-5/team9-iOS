//
//  FriendTabViewController.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/13.
//

import UIKit

class FriendTabViewController: BaseTabViewController<FriendTabView> {

    var tableView: UITableView {
        tabView.friendTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
