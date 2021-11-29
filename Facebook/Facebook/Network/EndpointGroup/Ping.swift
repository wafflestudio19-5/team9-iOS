//
//  Ping.swift
//  Facebook
//
//  Created by 박신홍 on 2021/11/26.
//

import Foundation

extension Endpoint {
    static var ping: Self {
        return Endpoint(path: "ping")
    }
    
    static func pingWithQuery(query: String) -> Self {
        return Endpoint(path: "ping", queryItems: [URLQueryItem(name: "key", value: query)])
    }
}
