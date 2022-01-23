//
//  Notification.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/17.
//

import Foundation

struct Notification: Codable, Identifiable {
    let id: Int
    let user: Int
    let content: ContentType
    let sender_preview: User
    let senders: [User]?
    var count: Int   // A님 외 N명 할 때, N (없으면 0으로 돌아옴)
    let post: Post?    // 알림이 발생한 게시물 정보
    let parent_comment: SimpleComment?  // 알림이 발생한 댓글
    let comment_preview: SimpleComment?
    let posted_at: String
    var is_checked: Bool
    let url: String // 알림을 눌렀을 때 이동할 url,
}

enum ContentType: String, Codable {
    case PostLike = "PostLike"
    case PostComment = "PostComment"
    case CommentComment = "CommentComment"
    case CommentLike = "CommentLike"
    case FriendRequest = "FriendRequest"
    case FriendAccept = "FriendAccept"
    case isFriend = "isFriend"
    case unknown = ""
    
    func message(user: String) -> String {
        switch self {
        case .PostLike: return "\(user)님이 회원님의 게시물을 좋아합니다."
        case .PostComment: return "\(user)님이 회원님의 게시물에 댓글을 남겼습니다."
        case .CommentComment: return "\(user)님의 게시물에 있는 회원님의 댓글에 답글을 남겼습니다"
        case .CommentLike: return "\(user)님이 회원님의 댓글을 좋아합니다: "
        case .FriendRequest: return "\(user)님이 친구 요청을 보냈습니다."
        case .FriendAccept: return "\(user)님이 회원님의 친구 요청을 수락했습니다."
        case .isFriend: return "\(user)님과 친구입니다."
        case .unknown: return ""
        }
    }
}
