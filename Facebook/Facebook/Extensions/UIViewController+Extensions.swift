//
//  Extensions.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/13.
//

import UIKit

extension UIViewController {
    
    func alert(title: String, message: String, action: String, subAction: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: subAction, style: .default))
        alert.addAction(UIAlertAction(title: action, style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func actionSheet(title: String, message: String?, action: (String, destructive: Bool)) {
        let sheet = UIAlertController(title: title, message: { _ -> String? in
            guard let message = message else { return nil }
            return message
        }(String.self), preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: action.0, style: action.destructive ? .destructive : .default))
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(sheet, animated: true, completion: nil)
    }
    
    func push(viewController: UIViewController) {
        let destination = viewController
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func changeRootViewController(to viewController: UIViewController, wrap: Bool = false) {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.changeRootViewController(viewController, wrap: wrap)
        }
    }
}
