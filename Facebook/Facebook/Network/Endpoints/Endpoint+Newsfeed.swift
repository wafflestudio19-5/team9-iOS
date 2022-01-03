//
//  Newsfeed.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/16.
//

import Foundation

extension Endpoint {
    static func newsfeed(cursor: String? = nil) -> Self {
        return Endpoint(path: "newsfeed/", cursor: cursor)
    }
    
    static func newsfeed(id: Int, cursor: String? = nil) -> Self {
        return Endpoint(path: "user/\(id)/newsfeed/", cursor: cursor)
    }
}
