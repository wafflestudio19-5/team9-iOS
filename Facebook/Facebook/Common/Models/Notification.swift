//
//  Notification.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/17.
//

import Foundation

struct Notification: Codable, Identifiable {
    let id: Int
    let user: Int  // 알림을 받는 User(current user)
    let post: Post    // 알림이 발생한 게시물 정보
    let parent_comment: SimpleComment?  // 알림이 발생한 댓글
    
    // sender_preview에서                parent_comment에서
    // PostComment: SimpleComment       comment_id, content, isFile
    // PostLike: User                   comment_id, content, isFile
    // CommentLike: User                SimpleComment
    // CommentComment: SimpleComment    SimpleComment
    // isFriend: User                   comment_id, content, isFile
    // FriendRequest: User              comment_id, content, isFile
    
    let sender_preview: User
    let content: String // 알림 내용: "PostLike", "PostComment", "CommentComment", "CommentLike", "FriendRequest", "FriendAccept", "isFriend" 중에 하나
    let posted_at: String
    var is_checked: Bool
    let url: String // 알림을 눌렀을 때 이동할 url,
    let senders: [User]
    var count: Int   // A님 외 N명 할 때, N (없으면 0으로 돌아옴)
}
