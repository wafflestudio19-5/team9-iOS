//
//  EditPostViewController.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/26.
//

import UIKit

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
        bindSubPostsData()
        configure(with: postToEdit)
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
}
