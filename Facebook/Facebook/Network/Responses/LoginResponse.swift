//
//  LoginResponse.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/19.
//

import Foundation

struct LoginResponse: Codable {
    let success: Bool
    let user: User
    let token: String
}
