//
//  Endpoint+Friend.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/14.
//

import Foundation

extension Endpoint {
    static func friend(id: Int, limit: Int, cursor: String? = nil) -> Self {
        return Endpoint(path: "user/\(id)/friend/", cursor: cursor, parameters: ["limit": limit])
    }
    
    static func friend(friendId: Int) -> Self {
        return Endpoint(path: "friend/", parameters: ["friend": friendId] )
    }
    
    static func friendRequest(cursor: String? = nil) -> Self {
        return Endpoint(path: "friend/request/", cursor: cursor)
    }
    
    static func friendRequest(id: Int) -> Self {
        return Endpoint(path: "friend/request/\(id)/")
    }
}
