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
    var sender_preview: User
    var senders: [User]
    var count: Int
    let post: Post?
    let parent_comment: SimpleComment?
    var comment_preview: SimpleComment?
    var posted_at: String
    var is_checked: Bool
    var is_accepted: Bool
    let url: String
}

extension Notification {
    func message() -> (message: String, users: [String]) {
        var message = "\(sender_preview.username)"
        var users: [String] = []
        
        /// 알림을 보내는 유저의 수에 따른 메시지 반환
        message.append( { () -> String in
            switch senders.count {
            case 0: return "님이 "
            case 1: return "님과 \(senders[0].username)님이 "
            case 2: return ", \(senders[0].username), \(senders[1].username)님이 "
            default: return "님, \(senders[0].username)님 외 \(count - 1)명이 "
            }
        }())
        
        /// 알림의 종류에 따른 메시지 반환
        message.append( { () -> String in
            switch self.content {
            case .PostLike: return "회원님의 게시물을 좋아합니다."
            case .PostComment: return "회원님의 게시물에 댓글을 남겼습니다"
            case .CommentComment: return "\(post?.author?.id == id ? "회원" : post?.author?.username ?? "")님의 게시물에 있는 회원님의 댓글에 답글을 남겼습니다"
            case .CommentLike: return "회원님의 \(parent_comment?.is_file == "photo" ? "사진 " : (parent_comment?.is_file == "sticker" ? "스티커 " : ""))댓글을 좋아합니다: \"\(parent_comment?.content ?? "")\""
            case .FriendRequest: return "친구 요청을 보냈습니다."
            case .FriendAccept: return "회원님의 친구 요청을 수락했습니다."
            case .PostTag: return "게시물에 회원님을 태그했습니다."
            case .CommentTag: return "댓글에서 회원님을 언급했습니다"
            case .unknown: return ""
            }
        }())
        
        /// 알림에 등장하는 username을 모두 배열에 저장 후 반환
        /// 우선은 빠른 구현을 위해 이 함수 내부에 함께 넣었습니다(추후 정리)
        users.append(sender_preview.username)
        senders.forEach { user in
            users.append(user.username)
        }
        users.append((post?.author?.id == id) ? "" : (post?.author?.username ?? ""))
        
        return (message, users)
    }
}

enum ContentType: String, Codable {
    case PostLike = "PostLike"
    case PostComment = "PostComment"
    case CommentComment = "CommentComment"
    case CommentLike = "CommentLike"
    case FriendRequest = "FriendRequest"
    case FriendAccept = "FriendAccept"
    case PostTag = "PostTag"
    case CommentTag = "CommentTag"
    case unknown = ""
}
