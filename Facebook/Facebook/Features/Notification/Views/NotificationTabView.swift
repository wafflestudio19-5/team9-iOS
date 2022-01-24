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
    
    let refreshControl = UIRefreshControl()
    
    lazy var newNotificationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        label.text = "새로운 알림"
        return label
    }()
    
    lazy var oldNotificationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        label.text = "이전 알림"
        return label
    }()
    
    
    lazy var bottomSheetView: UIView = {
        return BottomSheetView()
    }()
    
    let notificationTableView = ResponsiveTableView(frame: CGRect.zero, style: .grouped)
    
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
        notificationTableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseIdentifier)
        notificationTableView.refreshControl = refreshControl
        notificationTableView.backgroundColor = .white
    }
    
    func showBottomSheetView() {
        self.insertSubview(bottomSheetView, aboveSubview: self)
        bottomSheetView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        self.layoutIfNeeded()
    }
    
    func dismissBottomSheetView() {
        bottomSheetView.removeFromSuperview()
        self.layoutIfNeeded()
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
