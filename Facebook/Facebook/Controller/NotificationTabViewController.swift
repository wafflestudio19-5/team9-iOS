//
//  NotificationTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class NotificationTabViewController<View: NotificationTabView>: BaseViewController {

    override func loadView() { view = View() }
    
    private final var notification: NotificationTabView { return view as! View }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }


}
