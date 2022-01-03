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
    let content: String
    let likes: Int
    let posted_at: String?
    let comments: Int
    let file: String?
    
    let mainpost: Int?
    let subposts: [SubPost]
}

// To be deprecated
struct SubPost: Codable, Identifiable {
    let id: Int
    let content: String
    let likes: Int
    let posted_at: String?
    let comments: Int
    let file: String?
    
    let mainpost: Int?
}
