//
//  UserProfileModel.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/31.
//

import Foundation

struct UserProfile: Codable, Identifiable  {
    let id: Int
    let first_name: String
    let last_name: String
    let username: String
    let email: String
    let birth: String
    let gender: String
    let self_intro: String
    let profile_image: String?
    let cover_image: String?
    var friend_info: String
    let company: [Company]
    let university: [University]
    
    static func getDummyProfile() -> Self {
        return UserProfile(id: -1, first_name: "", last_name: "", username: "", email: "", birth: "", gender: "", self_intro: "", profile_image: nil, cover_image: nil, friend_info: "", company: [], university: [])
    }
    
    static func getDummyProfile(from user: User) -> Self {
        return UserProfile(id: user.id, first_name: "", last_name: "", username: user.username, email: user.email, birth: "", gender: "", self_intro: "", profile_image: user.profile_image, cover_image: nil, friend_info: "", company: [], university: [])
    }
}

struct Company: Codable  {
    var id: Int?
    var name: String?
    var role: String?
    var location: String?
    var join_date: String?
    var leave_date: String?
    var is_active: Bool?
    var detail: String?
}

struct University: Codable  {
    var id: Int?
    var name: String?
    var major: String?
    var join_date: String?
    var graduate_date: String?
    var is_active: Bool?
}
