//
//  PostLikeResponse.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/03.
//

import Foundation

struct LikeResponse: Codable {
    let likes: Int
    let is_liked: Bool
}
