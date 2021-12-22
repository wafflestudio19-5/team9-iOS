//
//  UserProfileModel.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/31.
//

import Foundation

struct UserProfile: Codable  {
    let id: Int?
    var first_name: String
    var last_name: String
    let username: String?
    let email: String?
    var birth: String
    var gender: String
    var self_intro: String?
    var profile_image: String?
    var cover_image: String?
    let company: [Company]?
    let university: [University]?
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
