//
//  SearchViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit

class SearchViewController: UIViewController {
    var hiddenTF = UITextField()
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white  // 이거 없으면 애니메이션 글리치 생김
        setNavigationBarItems()
        hiddenTF.isHidden = true
        view.addSubview(hiddenTF)
        hiddenTF.becomeFirstResponder()
    }
    
    func setNavigationBarItems() {
        searchBar.placeholder = "Facebook 검색"
        self.navigationItem.titleView = searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
}
