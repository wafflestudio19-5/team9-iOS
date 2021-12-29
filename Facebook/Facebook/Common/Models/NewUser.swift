//
//  NewUser.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/24.
//

import Foundation

struct NewUser: Codable {
    var email: String?
    var first_name: String?
    var last_name: String?
    var birth: String?
    var gender: String?
    var password: String?
}
