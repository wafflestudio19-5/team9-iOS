//
//  BaseTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import RxSwift
import RxGesture

class BaseTabViewController<View: UIView>: UIViewController {

    private let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: nil, action: nil)
    
    private let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(weight: .black)), style: .plain, target: nil, action: nil)
    
    let disposeBag = DisposeBag()
    
    override func loadView() { view = View() }
    
    var tabView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItems()
        bindNavigationBarItems()
        self.navigationItem.backButtonTitle = ""
    }
    
    func setNavigationBarItems(withEditButton: Bool = false) {
        switch withEditButton {
        case true: self.navigationItem.rightBarButtonItems = [searchButton, editButton]
        case false: self.navigationItem.rightBarButtonItem = searchButton
        }
    }
    
    private func bindNavigationBarItems() {
        searchButton.rx.tap.bind { _ in
            print("search button tapped")
            // searchViewController 띄우기
            let searchViewController = SearchViewController()
            
            self.navigationController?.pushViewController(searchViewController, animated: true)
        }.disposed(by: disposeBag)
        
        editButton.rx.tap.bind { _ in
            print("edit button tapped")
            // editProfileViewController 띄우기
        }.disposed(by: disposeBag)
    }

}
