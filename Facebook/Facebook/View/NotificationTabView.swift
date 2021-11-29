//
//  NotificationTabView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class NotificationTabView: UIView {
    
    let notificationTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(notificationTableView)
        
        notificationTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notificationTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            notificationTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            notificationTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            notificationTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
