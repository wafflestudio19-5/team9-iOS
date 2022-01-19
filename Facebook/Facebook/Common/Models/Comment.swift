//
//  Comment.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/03.
//

import Foundation
import UIKit


struct Comment: Codable, Identifiable {
    let id: Int
    var post_id: Int?
    let author: User
    var content: String
    let file: String?
    var likes: Int
    let children_count: Int?
    let children: [Comment]?
    var is_liked: Bool
    let depth: Int
    let parent: Int?
    let posted_at: String
    
    var profileImageSize: CGFloat {
        return depth > 0 ? 30 : 40
    }
    
    var leftMargin: CGFloat {
        switch depth {
        case 0:
            return 10
        case 1:
            return 10 + (40 + 4)
        default:
            return 10 + (40 + 4) + (30 + 4)
        }
    }
}

/// 댓글 알림을 받아올 때 이용되는 댓글 모델입니다.
struct SimpleComment: Codable, Identifiable {
    let user: User
    let id: Int
    let content: String
    let file: String
    
    enum CodingKeys: String, CodingKey {
        case user
        case id = "comment_id"
        case content
        case file
    }
}
