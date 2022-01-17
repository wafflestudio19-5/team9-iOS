//
//  NotificationTabView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit
import SnapKit

class NotificationTabView: UIView {
    
    let largeTitleLabel = UILabel()
    
    let notificationTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView() {
        largeTitleLabel.text = "알림"
        largeTitleLabel.font = .systemFont(ofSize: 24.0, weight: .semibold)
        largeTitleLabel.textColor = .black
    }
    
    private func setLayoutForView() {
        self.addSubview(notificationTableView)
        
        notificationTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
