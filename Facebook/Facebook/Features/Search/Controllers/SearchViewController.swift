//
//  SearchViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    var hiddenTF = UITextField()
    private let searchBar = UISearchBar()
    private let disposeBag = DisposeBag()
    private let viewModel = SearchPaginationViewModel(endpoint: .search(query: "1"))
    
    override func loadView() {
        view = SearchView()
    }
    
    var searchView: SearchView {
        guard let view = view as? SearchView else { fatalError("View 초기화 오류") }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white  // 이거 없으면 애니메이션 글리치 생김
        setNavigationBarItems()
        hiddenTF.isHidden = true
        view.addSubview(hiddenTF)
        hiddenTF.becomeFirstResponder()
        bind()
    }
    
    private func setNavigationBarItems() {
        searchBar.placeholder = "Facebook 검색"
        self.navigationItem.titleView = searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    private func bind() {
        searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty {
                    self.viewModel.clearData()
                    return
                }
                self.viewModel.setQuery(query)
                self.viewModel.refresh()
            }
            .disposed(by: disposeBag)
        
        viewModel.dataList
            .bind { data in
                print(data)
            }
            .disposed(by: disposeBag)
    }
}
