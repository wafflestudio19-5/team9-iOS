//
//  Endpoint+Notification.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/21.
//

import Foundation

extension Endpoint {
    static func notification(cursor: String? = nil) -> Self {
        return Endpoint(path: "notices/", cursor: cursor)
    }
}
