//
//  SubPostViewController.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/11.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa
import Kingfisher

class SubPostsViewController: UIViewController {
    
    var post: Post
    private let disposeBag = DisposeBag()
    var subpostsDataSource = BehaviorRelay<[Post]>(value: [])
    var isPrefetching = BehaviorRelay<Bool>(value: true)
    
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
    
    var mainPostView: PostContentView {
        return subPostsView.mainPostHeader
    }
    
    init(post: Post) {
        self.post = post
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
        
        // tableView의 panGesture보다 swipe back 제스쳐가 우선이다.
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            tableView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
        }
        
        bind()
        startPrefetching()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.scrollEdgeAppearance = nil
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.adjustHeaderHeight()
    }
    
    private func bind() {
        StateManager.of.post.bind(with: subpostsDataSource).disposed(by: disposeBag)
        
        isPrefetching
            .bind { [weak self] prefetching in
                if !prefetching {
                    self?.tableView.hideBottomSpinner()
                } else {
                    self?.tableView.showBottomSpinner()
                }
            }
            .disposed(by: disposeBag)
        
        /// Subposts ~ 테이블뷰 바인딩
        subpostsDataSource
            .bind(to: tableView.rx.items(cellIdentifier: SubPostCell.reuseIdentifier, cellType: SubPostCell.self)) { row, post, cell in
                cell.configure(with: post)

                // 좋아요 버튼 바인딩
                cell.postContentView.likeButton.rx.tap.bind { _ in
                    cell.postContentView.like()
                    NetworkService.put(endpoint: .newsfeedLike(postId: post.id), as: LikeResponse.self)
                        .bind { response in
                            cell.postContentView.like(syncWith: response.1)
                        }
                        .disposed(by: cell.refreshingBag)
                }.disposed(by: cell.refreshingBag)
                
                // 댓글 버튼 바인딩
                cell.postContentView.commentButton.rx.tap.bind { [weak self] _ in
                    guard let self = self else { return }
                    self.presentCommentModalVC(to: cell.postContentView.post)
                }.disposed(by: cell.refreshingBag)
                
                // 공유 버튼 바인딩
                cell.postContentView.shareButton.rx.tap.bind { [weak self] _ in
                    guard let self = self else { return }
                    var postToShare = cell.postContentView.post
                    postToShare.author = self.post.author  // inject author information that is not present in subposts
                    self.presentCreatePostVC(sharing: postToShare, update: false)
                }.disposed(by: cell.refreshingBag)
            }
            .disposed(by: disposeBag)
        
        /// Subpost에 변동이 생기면 `StateManager`에서 해당 post를 업데이트한다.
        subpostsDataSource
            .filter { $0.count != 0 }
            .observe(on: MainScheduler.asyncInstance)  // suppresses error caused by cyclic dependency
            .bind { [weak self] subposts in
                guard let self = self else { return }
                self.post.subposts = subposts
                StateManager.of.post.dispatch(.init(data: self.post, operation: .edit))
            }
            .disposed(by: disposeBag)
        
        mainPostView.likeButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.mainPostView.like()
                NetworkService.put(endpoint: .newsfeedLike(postId: self.post.id), as: LikeResponse.self)
                    .bind { response in
                        self.mainPostView.like(syncWith: response.1)
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        mainPostView.commentButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            self.presentCommentModalVC(to: self.post)
        }.disposed(by: disposeBag)
        
        mainPostView.shareButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.presentCreatePostVC(sharing: self.post, update: false)
            }
            .disposed(by: disposeBag)
    }
    
    private func startPrefetching() {
        let urls = self.post.subposts?.map { $0.file }.compactMap { URL(string: $0 ?? "") }
        guard let urls = urls else {
            return
        }
        
        let prefetcher = ImagePrefetcher(urls: urls, options: [.processor(KFProcessors.shared.downsampling), .diskCacheExpiration(.never)]) { skippedResources, failedResources, completedResources in
            self.isPrefetching.accept(false)
            self.subpostsDataSource.accept(self.post.subposts ?? [])
        }
        prefetcher.start()
    }
    
    
}
