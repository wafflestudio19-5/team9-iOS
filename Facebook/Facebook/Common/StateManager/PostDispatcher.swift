//
//  PostDispatcher.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/09.
//

import Foundation

class PostDispatcher: Dispatcher<Post> {
    func dispatch(_ post: Post, commentCount: Int) {
        var post = post
        post.comments = commentCount
        asObservable.accept(post)
    }
    
    func dispatch(_ post: Post, syncWith response: LikeResponse) {
        var post = post
        post.likes = response.likes
        post.is_liked = response.is_liked
        asObservable.accept(post)
    }
}
