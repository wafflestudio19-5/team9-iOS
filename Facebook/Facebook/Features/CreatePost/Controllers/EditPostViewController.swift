//
//  EditPostViewController.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/26.
//

import UIKit
import RxSwift

class EditPostViewController: CreatePostViewController {
    
    var postToEdit: Post
    
    init(editing post: Post) {
        self.postToEdit = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "게시물 수정"
        configure(with: postToEdit)
        bindSubPostsData()
        bindEditing()
    }
    
    func configure(with post: Post) {
        createPostView.contentTextView.text = post.content
    }
    
    override func loadView() {
        view = CreatePostView(sharing: postToEdit.postSharing)
    }
    
    func bindSubPostsData() {
        let subposts = postToEdit.subposts?.map { SubPost(id: $0.id, pickerId: nil, pickerResult: nil, imageUrl: $0.file, prefetchedImage: nil, content: $0.content, data: nil)} ?? []
        subPostViewModel.subposts.accept(subposts)
    }
    
    func bindEditing() {
        self.createPostView.contentTextView.rx.text.orEmpty.bind { [weak self] text in
            self?.postToEdit.content = text
        }.disposed(by: disposeBag)
    }
    
    // TODO: Duplicate
    override func bindPostButton() {
        var callbackDisposeBag = DisposeBag()
        createPostView.postButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                // get the VC that presented this VC
                guard let rootTabBarController = self.presentingViewController as? RootTabBarController,
                      let newsfeedVC = rootTabBarController.newsfeedNavController.viewControllers.first as? NewsfeedTabViewController
                else { return }
                
                // dismiss current VC first
                self.dismiss(animated: true, completion: nil)
                
                // show progress bar with initial value (1%)
                let tempProgress = Progress()
                tempProgress.totalUnitCount = 100
                tempProgress.completedUnitCount = 1
                DispatchQueue.main.async {
                    newsfeedVC.headerViews.uploadProgressHeaderView.isHidden = false
                    newsfeedVC.headerViews.uploadProgressHeaderView.displayProgress(progress: tempProgress)
                }
                
                // load selected images as an array of data
                self.subPostViewModel.loadSubPostData { subposts in
                    NetworkService.update(endpoint: .newsfeed(editing: self.postToEdit, subposts: subposts))
                        .subscribe { event in
                            let request = event.element
                            let progress = request?.uploadProgress
                            DispatchQueue.main.async {
                                newsfeedVC.headerViews.uploadProgressHeaderView.displayProgress(progress: progress)
                            }
                            request?.responseDecodable(of: Post.self) { dataResponse in
                                guard let post = dataResponse.value else { return }
                                StateManager.of.post.dispatch(.init(data: post, operation: .edit))
                                newsfeedVC.headerViews.uploadProgressHeaderView.isHidden = true
                                callbackDisposeBag = DisposeBag()
                            }
                        }
                        .disposed(by: callbackDisposeBag)
                }
            }.disposed(by: disposeBag)
    }
}
