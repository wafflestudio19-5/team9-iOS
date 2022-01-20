//
//  NotificationTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class NotificationTabViewController: BaseTabViewController<NotificationTabView>, UIScrollViewDelegate {

    var tableView: UITableView {
        tabView.notificationTableView
    }
    
    private var dummyData = BehaviorRelay(value: [1...10])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tabView.largeTitleLabel)
        
        
        
        bind()
    }
    
    private func bind() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        dummyData.bind(to: tableView.rx.items(cellIdentifier: NotificationTableViewCell.reuseIdentifier, cellType: NotificationTableViewCell.self)) { index, content, cell in
            cell.configure(content: "IQUNIX에서 새로운 동영상을 게시했습니다: 'L80 Xmas Edition Wireless Mechanical Keyboard IQUNIX에서 새로운 동영상을 게시했습니다", timeStamp: "17시간", subcontent: "키보드 사고싶다")
        }.disposed(by: disposeBag)
        
    }
    
}
