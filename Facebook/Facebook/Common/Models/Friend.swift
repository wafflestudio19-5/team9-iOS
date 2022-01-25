//
//  Friend.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/14.
//

import Foundation

struct FriendRequestCreate: Codable {
    let id: Int
    let sender_profile: User
    let created: String?
    let sender: Int
    let receiver: Int
}
