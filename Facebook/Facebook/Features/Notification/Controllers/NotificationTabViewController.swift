//
//  NotificationTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class NotificationTabViewController: BaseTabViewController<NotificationTabView> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func popupView() {
        let alert = UIAlertController(title: "알림", message: "메세지 샘플", preferredStyle: .actionSheet)
        let defaultAction =  UIAlertAction(title: "default", style: UIAlertAction.Style.default)
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
