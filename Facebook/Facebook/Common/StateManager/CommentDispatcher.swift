//
//  CommentDispatcher.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/09.
//

import Foundation
import RxSwift
import RxRelay

class CommentDispatcher: Dispatcher<Comment> {
    
    var postId: Int?
    
    func bind(postId: Int, with dataSource: BehaviorRelay<[Comment]>) -> Disposable {
        self.postId = postId
        return self.bind(with: dataSource)
    }
    
    override func _insert(dataSource: BehaviorRelay<[Comment]>, signal: Signal<Comment>) {
        guard case .insert(let index) = signal.operation else { return }
        guard let postId = postId else {
            print("postId not found.")
            return
        }
        // postId가 다른 경우
        if signal.data.post_id != postId {
            return
        }
        var dataList = dataSource.value
        dataList.insert(signal.data, at: index)
        dataSource.accept(dataList)
    }
    
    override func _delete(dataSource: BehaviorRelay<[Comment]>, signal: Signal<Comment>) {
        guard case .delete(let index) = signal.operation else { return }
        guard let postId = postId else {
            print("postId not found.")
            return
        }
        if signal.data.post_id != postId {
            return
        }
        var dataList = dataSource.value
        dataList.remove(at: index)
        dataSource.accept(dataList)
    }
    
    
    func dispatch(_ comment: Comment, syncWith response: LikeResponse) {
        var comment = comment
        comment.likes = response.likes
        comment.is_liked = response.is_liked
        dispatchedSignals.accept(.init(data: comment, operation: .edit))
    }
}
