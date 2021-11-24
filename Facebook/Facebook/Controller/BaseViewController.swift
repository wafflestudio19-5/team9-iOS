//
//  BaseViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import RxSwift
import RxGesture

class BaseViewController: UIViewController {

    private let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: nil, action: nil)
    
    private let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(weight: .black)), style: .plain, target: nil, action: nil)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItems()
        bindView()
    }
    
    func setNavigationBarItems(withEditButton: Bool = false) {
        switch withEditButton {
        case true: self.navigationItem.rightBarButtonItems = [searchButton, editButton]
        case false: self.navigationItem.rightBarButtonItem = searchButton
        }
    }
    
    private func bindView() {
        searchButton.rx.tap.bind { _ in
            print("search button tapped")
            // searchViewController 띄우기
        }.disposed(by: disposeBag)
        
        editButton.rx.tap.bind { _ in
            print("edit button tapped")
            // editProfileViewController 띄우기
        }.disposed(by: disposeBag)
    }

}
