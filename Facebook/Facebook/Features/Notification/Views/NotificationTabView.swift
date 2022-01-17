//
//  NotificationTabView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit
import SnapKit
import SwiftUI

class NotificationTabView: UIView {
    
    let largeTitleLabel = UILabel()
    
    let notificationTableView = ResponsiveTableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyleForView()
        setLayoutForView()
        configureTableView()
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
    
    private func configureTableView() {
        notificationTableView.separatorStyle = .none
        notificationTableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.reuseIdentifier)
    }
}


struct NotificationViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = NotificationTabView()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct NotificationViewPreview: PreviewProvider {
    static var previews: some View {
        VStack{
            Spacer()
            NotificationViewRepresentable()
            Spacer()
        }.preferredColorScheme(.light).previewDevice("iPhone 12 Pro").background(.white)
    }
}
