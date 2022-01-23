//
//  PostDispatcher.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/09.
//

import Foundation
import RxSwift
import RxRelay

class PostDispatcher: Dispatcher<Post> {
    
    func dispatch(_ post: Post, commentCount: Int) {
        var post = post
        post.comments = commentCount
        dispatchedSignals.accept(.init(data: post, operation: .edit))
    }
    
    func dispatch(_ post: Post, syncWith response: LikeResponse) {
        var post = post
        post.likes = response.likes
        post.is_liked = response.is_liked
        dispatchedSignals.accept(.init(data: post, operation: .edit))
    }
    
    override func _edit(dataSource: BehaviorRelay<[Post]>, signal: Signal<Post>) {
        var dataList = dataSource.value
        let index = dataList.firstIndex(where: { $0.id == signal.data.id })
        var found = false
        if let index = index {
            dataList[index] = signal.data
            found = true
        }
        
        // 공유된 게시글에서도 검색한다.
        for (index, post) in dataList.enumerated() {
            if let shared_post = post.shared_post, shared_post.id == signal.data.id {
                dataList[index].shared_post = signal.data.asSharedPost()
                found = true
            }
        }
        if found {
            dataSource.accept(dataList)
        }
    }
}
