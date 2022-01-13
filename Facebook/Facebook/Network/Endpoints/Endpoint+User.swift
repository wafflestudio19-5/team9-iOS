//
//  User.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/18.
//

import Foundation

extension Endpoint {
    static func login(email: String, password: String) -> Self {
        return Endpoint(path: "login/", parameters: ["email": email, "password": password])
    }
    
    static func search(query: String) -> Self {
        return Endpoint(path: "search/", queryItems: [.init(name: "q", value: query)])
    }
}
