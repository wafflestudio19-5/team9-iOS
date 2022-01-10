//
//  MenuTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/10.
//

import UIKit
import RxSwift
import RxGesture

class MenuTabViewController: BaseTabViewController<MenuTabView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tabView.largeTitleLabel)
        bind()
    }
    
    private func bind() {
        tabView.logoutButton.rx.tapGesture().bind { [weak self] _ in
            print("logout button tapped")
        }.disposed(by: disposeBag)
    }
}
