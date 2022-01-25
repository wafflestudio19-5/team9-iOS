//
//  User.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/19.
//

import Foundation

struct User: Codable, Identifiable {
    let email: String
    let id: Int
    var is_valid: Bool
    let profile_image: String?
    let username: String
    let is_friend: Bool?
    let mutual_friends: FriendInfo?
    var friend_info: String?
}

struct FriendInfo: Codable {
    let count: Int
}
