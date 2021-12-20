//
//  URL+QueryParameters.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/19.
//

import Foundation

extension URL {
    var queryParameters: QueryParameters { return QueryParameters(url: self) }
}

class QueryParameters {
    let queryItems: [URLQueryItem]
    init(url: URL?) {
        queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems ?? []
    }
    subscript(name: String) -> String? {
        return queryItems.first(where: { $0.name == name })?.value
    }
}
