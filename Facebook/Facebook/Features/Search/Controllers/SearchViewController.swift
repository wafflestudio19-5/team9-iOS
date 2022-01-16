//
//  SearchViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

class SearchViewController: UIViewController {
    var hiddenTF = UITextField()
    private let searchBar = UISearchBar()
    private let disposeBag = DisposeBag()
    private let viewModel = SearchPaginationViewModel(endpoint: .search(query: "1"))
    var didLoad = false
    
    override func loadView() {
        view = SearchView()
    }
    
    var searchView: SearchView {
        guard let view = view as? SearchView else { fatalError("View 초기화 오류") }
        return view
    }
    
    var tableView: UITableView {
        return searchView.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white  // 이거 없으면 애니메이션 글리치 생김
        setNavigationBarItems()
        bind()
        bindKeyboardHeight()
        tableView.delegate = self
        
        hiddenTF.isHidden = true
        view.addSubview(hiddenTF)
        hiddenTF.becomeFirstResponder()
    }
    
    private func setNavigationBarItems() {
        searchBar.placeholder = "Facebook 검색"
        self.navigationItem.titleView = searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didLoad {
            searchBar.becomeFirstResponder()
        }
        didLoad = true
    }
    
    private func bindKeyboardHeight() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                self.tableView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardVisibleHeight + self.view.safeAreaInsets.bottom)
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
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
            .bind(to: tableView.rx.items(cellIdentifier: SearchResultCell.reuseIdentifier, cellType: SearchResultCell.self)) { row, data, cell in
                cell.configure(with: data)
            }
            .disposed(by: disposeBag)
    }
}


extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        let userId = viewModel.dataList.value[indexPath.row].id
        self.push(viewController: ProfileTabViewController(userId: userId))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
