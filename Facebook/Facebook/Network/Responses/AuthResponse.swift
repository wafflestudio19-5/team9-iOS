//
//  AuthResponse.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/29.
//

import Foundation

struct AuthResponse: Codable {
    let user: Author
    let token: String
}
