//
//  SearchViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit

class SearchViewController: UIViewController {

    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItems()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white  // 이거 없으면 애니메이션 글리치 생김
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.setAnimationsEnabled(false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.setAnimationsEnabled(true)
    }
    
    func setNavigationBarItems() {
        searchBar.placeholder = "Facebook 검색"
        self.navigationItem.titleView = searchBar
    }

}
