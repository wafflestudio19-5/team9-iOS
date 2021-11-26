//
//  Ping.swift
//  Facebook
//
//  Created by 박신홍 on 2021/11/26.
//

import Foundation

extension Endpoint {
    static var ping: URL {
        return Endpoint(path: "ping").url
    }
    
    static func pingWithQuery(query: String) -> URL {
        return Endpoint(path: "ping", queryItems: [URLQueryItem(name: "key", value: query)]).url
    }
}
