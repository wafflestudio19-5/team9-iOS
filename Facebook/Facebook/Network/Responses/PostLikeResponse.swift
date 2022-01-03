//
//  PostLikeResponse.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/03.
//

import Foundation

struct PostLikeResponse: Codable {
    let likes: Int
    let likeusers: [User]
}
