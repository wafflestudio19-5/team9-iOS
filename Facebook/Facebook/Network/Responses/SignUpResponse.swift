//
//  SignUpResponse.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/29.
//

import Foundation

struct SignUpResponse: Codable {
    let user: User
    let token: String
}
