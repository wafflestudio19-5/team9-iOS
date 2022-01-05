//
//  Post.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/16.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: Int
    let author: User?
    var content: String
    var likes: Int
    var is_liked: Bool
    let posted_at: String?
    var comments: Int
    let file: String?
    
    let mainpost: Int?
    let subposts: [Post]?
    
    static func getDummyPost() -> Self {
        return Post(id: -1, author: nil, content: "", likes: -1, is_liked: false, posted_at: nil, comments: -1, file: nil, mainpost: nil, subposts: nil)
    }
}

// To be deprecated
//struct SubPost: Codable, Identifiable {
//    let id: Int
//    let content: String
//    let likes: Int
//    let posted_at: String?
//    let comments: Int
//    let file: String?
//
//    let mainpost: Int?
//}
