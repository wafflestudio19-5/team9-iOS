//
//  User.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/19.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let username: String
    let profile_image: String?
    let email: String
}
