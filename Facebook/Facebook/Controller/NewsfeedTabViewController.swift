//
//  NewsfeedTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import Alamofire
import RxSwift
import RxAlamofire

class NewsfeedTabViewController: BaseTabViewController<NewsfeedTabView> {
    
    var tableView: UITableView {
        tabView.newsfeedTableView
    }
    
    let dummyObservable = Observable.just(1...200)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView()
    }
    
    func bindTableView() {
        dummyObservable.bind(to: tableView.rx.items(cellIdentifier: "PostCell", cellType: PostTableViewCell.self)) {
            row, item, cell in
            cell.contentLabel.text = "\(item)번째 포스트"
        }.disposed(by: disposeBag)
    }
}

