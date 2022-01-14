//
//  Endpoint+Friend.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/14.
//

import Foundation

extension Endpoint {
    static func friend(id: Int) -> Self {
        return Endpoint(path: "user/\(id)/friend/", parameters: ["limit": 20])
    }
    
    static func friendRequest(id: Int) -> Self {
        return Endpoint(path: "friend/request/\(id)/")
    }
}
