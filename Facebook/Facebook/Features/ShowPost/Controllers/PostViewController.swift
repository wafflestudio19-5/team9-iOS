//
//  PostViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/05.
//

import UIKit
import RxSwift
import RxCocoa

class PostViewController: UIViewController {
    var post: Post
    let disposeBag = DisposeBag()
    let dummyObservable = Observable.just(1...10)
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PostDetailView()
    }
    
    var postView: PostDetailView {
        guard let view = view as? PostDetailView else { fatalError("PostView가 제대로 초기화되지 않음.") }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postView.postContentHeaderView.configure(with: post)
        bindTableView()
    }
    
    func bindTableView(){
        // TODO: Binding for comment table view (use `PaginationViewModel`)
    }
}

