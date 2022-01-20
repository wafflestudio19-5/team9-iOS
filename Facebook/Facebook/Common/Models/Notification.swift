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
    let content: ContentType
    let posted_at: String
    var is_checked: Bool
    let url: String // 알림을 눌렀을 때 이동할 url,
    let senders: [User]
    var count: Int   // A님 외 N명 할 때, N (없으면 0으로 돌아옴)
}

enum ContentType: Codable {
    case PostLike
    case PostComment
    case CommentComment
    case CommentLike
    case FriendRequest
    case FriendAccept
    case isFriend
    case unknown
    
    init(content: String) {
        switch content {
        case "PostLike": self = .PostLike
        case "PostComment": self = .PostComment
        case "CommentComment": self = .CommentComment
        case "CommentLike": self = .CommentLike
        case "FriendRequest": self = .FriendRequest
        case "FriendAccept": self = .FriendAccept
        case "isFriend": self = .isFriend
        default: self = .unknown
        }
    }
    
    func message() -> String {
        switch self {
        case .PostLike: return "님이 회원님의 게시물을 좋아합니다."
        case .PostComment: return "님이 회원님의 게시물에 댓글을 남겼습니다."
        case .CommentComment: return "님의 게시물에 있는 회원님의 댓글에 답글을 남겼습니다"
        case .CommentLike: return "님이 회원님의 댓글을 좋아합니다: "
        case .FriendRequest: return "님이 친구 요청을 보냈습니다."
        case .FriendAccept: return "님이 회원님의 친구 요청을 수락했습니다."
        case .isFriend: return "isFreind?"
        case .unknown: return ""
        }
    }
}
