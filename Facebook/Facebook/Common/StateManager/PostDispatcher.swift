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
        
        // 공유된 게시글 또는 공유된 게시글의 subpost 중에서도 검색한다.
        // O(k*mn), where k: number of dataSource bound, m: number of posts, n: avg. number of subposts
        var loop = 0
        for (index, post) in dataList.enumerated() {
            guard var sharedPost = post.shared_post else { continue }
            if sharedPost.id == signal.data.id {
                var newPost = signal.data
                newPost.author = sharedPost.author  // 여기서 newPost는 불완전한 데이터이므로 asSharedPost를 호출하기 전에 데이터를 채워주어야 한다.
                newPost.subposts = sharedPost.subposts
                dataList[index].shared_post = newPost.asSharedPost()
                found = true
            }
            loop += 1
            guard var subPostsOfSharedPost = sharedPost.subposts, subPostsOfSharedPost.count > 0 else { continue }
            for (subindex, subpost) in subPostsOfSharedPost.enumerated() {
                if subpost.id == signal.data.id {
                    subPostsOfSharedPost[subindex] = signal.data
                    sharedPost.subposts = subPostsOfSharedPost
                    dataList[index].shared_post = sharedPost
                    found = true
                    loop += 1
                }
            }
        }
        
        if loop > 0 {
            print("@PostDispatcher.edit:", loop)
        }
        
        if found {
            dataSource.accept(dataList)
        }
    }
}
