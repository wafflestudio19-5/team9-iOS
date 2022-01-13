//
//  User.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/19.
//

import Foundation

struct Author: Codable, Identifiable {
    let id: Int
    let email: String
    let username: String
    let profile_image: String?
}
