//
//  SyncManager.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/09.
//

import Foundation
import RxSwift
import RxRelay

struct SyncManager {
    static let postUpdated = PublishRelay<Post>()
    
    static func update(with _post: Post) {
        postUpdated.accept(_post)
    }
    
    static func update(with _post: Post, commentCount: Int) {
        var post = _post
        post.comments = commentCount
        postUpdated.accept(post)
    }
    
    static func update(with _post: Post, syncWith response: LikeResponse) {
        var post = _post
        post.likes = response.likes
        post.is_liked = response.is_liked
        postUpdated.accept(post)
    }
}
