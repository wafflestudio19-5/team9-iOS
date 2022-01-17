//
//  Notification.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/17.
//

import Foundation

struct Notification: Codable, Identifiable {
    let id: Int
    let user: User  // 알림을 받는 User(current user)
    let post: String    // 알림이 발생한 게시물 정보
    let parent_comment: String?  // 알림이 발생한 댓글
    let sender_preview: String  // 알림을 보낸 유저들 중 가장 최신 유저에 대한 정보를 dict로 ('A님 외 몇명'에서 A),
    let content: String //알림 내용, "PostLike", "PostComment", "CommentComment", "CommentLike", "FriendRequest", "FriendAccept", "isFriend" 중에 하나
    let posted_at: String   // 알림 발생한 시간, ~분전
    var is_checked: Bool    // 알림을 확인했는지 여부 True/False, 디폴트로 False
    let url: String // 알림을 눌렀을 때 이동할 url,
    let senders: String? // A님 외 N명 할 때, N명을 누를 시 뜨는 유저들 정보를 dict list로,
    let count: String?   // A님 외 N명 할 때, N
}
