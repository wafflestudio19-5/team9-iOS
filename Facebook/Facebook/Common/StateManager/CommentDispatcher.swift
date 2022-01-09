//
//  CommentDispatcher.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/09.
//

import Foundation

class CommentDispatcher: Dispatcher<Comment> {
    
    func dispatch(_ comment: Comment, syncWith response: LikeResponse) {
        var comment = comment
        comment.likes = response.likes
        comment.is_liked = response.is_liked
        asObservable.accept(comment)
    }
    
}
