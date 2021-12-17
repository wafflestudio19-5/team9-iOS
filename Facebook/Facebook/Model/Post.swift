//
//  Post.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/16.
//

import Foundation

struct Post: Codable {
    let id: Int?
    let author: Int
    let content: String
    let likes: Int
    let posted_at: String?
    let images: [String]?
}
