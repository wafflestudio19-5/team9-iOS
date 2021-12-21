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
    }
    
    func setNavigationBarItems() {
        searchBar.placeholder = "Facebook 검색"
        self.navigationItem.titleView = searchBar
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
