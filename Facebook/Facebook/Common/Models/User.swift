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
    var is_valid: Bool?
    let profile_image: String?
    let username: String
    let is_friend: Bool?
    let mutual_friends: FriendInfo?
    var friend_info: String?
    
    static func changeFriendInfo(user: User, friendInfo: String) -> Self {
        return User(email: user.email, id: user.id, is_valid: user.is_valid, profile_image: user.profile_image, username: user.username, is_friend: user.is_friend, mutual_friends: user.mutual_friends, friend_info: friendInfo)
    }
    
    static func getUserFromProfile(userProfile: UserProfile, is_freind: Bool) -> Self {
        return User(email: userProfile.username, id: userProfile.id, is_valid: true, profile_image: userProfile.profile_image, username: userProfile.username, is_friend: is_freind, mutual_friends: nil, friend_info: userProfile.friend_info)
    }
}

struct FriendInfo: Codable {
    let count: Int
}
