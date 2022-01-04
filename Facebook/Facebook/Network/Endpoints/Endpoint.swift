//
//  Endpoint.swift
//  Facebook
//
//  Created by 박신홍 on 2021/11/26.
//

import Foundation
import Alamofire

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
    var page: Int?  // special case로 처리
    var cursor: String?  // special case로 처리
    var parameters: Parameters?  // request body (data)
    var multipartFormDataBuilder: ((MultipartFormData) -> Void)?  // multipart data builder when uploading files
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.path = "/api/v1/" + path
        components.queryItems = queryItems
        
        if let page = page {
            components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
        }
        if let cursor = cursor {
            components.queryItems?.append(URLQueryItem(name: "cursor", value: cursor))
        }
        
        // for production
//        components.host = "ec2-3-34-188-255.ap-northeast-2.compute.amazonaws.com"
        
        // for development
        components.host = "127.0.0.1"
        components.port = 8000
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
}

extension Endpoint {
    mutating func withPage(page: Int) -> Self {
        self.page = page
        return self
    }
    
    mutating func withCursor(cursor: String?) -> Self {
        self.cursor = cursor
        return self
    }
}
