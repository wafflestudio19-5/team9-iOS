//
//  SubPostViewController.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/11.
//

import UIKit
import RxRelay
import RxSwift

class SubPostsViewController: UIViewController {
    
    var post: Post
    private let disposeBag = DisposeBag()
    var subpostsDataSource: BehaviorRelay<[Post]>
    
    override func loadView() {
        view = SubPostsView(post: post)
    }
    
    var subPostsView: SubPostsView {
        guard let view = view as? SubPostsView else { fatalError("SubPostsView가 제대로 초기화되지 않음.") }
        return view
    }
    
    var tableView: UITableView {
        return subPostsView.subpostsTableView
    }
    
    init(post: Post) {
        self.post = post
        self.subpostsDataSource = BehaviorRelay<[Post]>(value: Array(Array(repeating: post.subposts ?? [], count: 10000).joined()) ?? [])
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        
        if let author = post.author {
            self.title = "\(author.username)님의 게시물"
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.standardAppearance = standardAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        
        // tableView의 panGesture보다 swipe back 제스쳐가 우선이다.
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            tableView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
        }
        
        bind()
    }
    
    private func bind() {
        StateManager.of.post.bind(with: subpostsDataSource).disposed(by: disposeBag)
        
        subpostsDataSource
            .bind(to: tableView.rx.items(cellIdentifier: SubPostCell.reuseIdentifier, cellType: SubPostCell.self)) { row, post, cell in
                cell.configureCell(with: post)
            }
            .disposed(by: disposeBag)
    }
    
    
}
