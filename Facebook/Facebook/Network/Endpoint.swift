//
//  Endpoint.swift
//  Facebook
//
//  Created by 박신홍 on 2021/11/26.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "ec2-3-34-188-255.ap-northeast-2.compute.amazonaws.com"
        components.path = "/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
}
