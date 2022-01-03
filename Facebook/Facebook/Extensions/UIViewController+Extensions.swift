//
//  Extensions.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/13.
//

import UIKit

extension UIViewController {
    
    func alert(title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func push(viewController: UIViewController) {
        let destination = viewController
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func changeRootViewController(to viewController: UIViewController) {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.changeRootViewController(viewController)
        }
    }
}
