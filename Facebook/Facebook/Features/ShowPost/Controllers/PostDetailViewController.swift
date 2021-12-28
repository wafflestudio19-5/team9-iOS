//
//  PostViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/05.
//

import UIKit
import RxSwift
import RxCocoa

class PostDetailViewController: UIViewController {
    var post: Post
    let disposeBag = DisposeBag()
    
    lazy var authorHeaderView: AuthorInfoHeaderView = {
        let view = AuthorInfoHeaderView(imageWidth: 40)
        view.configure(with: post)
        return view
    }()
    
    private lazy var leftChevronButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
        button.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        return button
    }()
    
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
        setLeftBarButtonItems()
    }
    
    func setLeftBarButtonItems() {
        let stackview = UIStackView.init(arrangedSubviews: [leftChevronButton, authorHeaderView])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 10
        
        let leftBarButtons = UIBarButtonItem(customView: stackview)
        navigationItem.leftBarButtonItem = leftBarButtons
    }
    
    
    
    func bindTableView(){
        // TODO: Binding for comment table view (use `PaginationViewModel`)
    }
}

