//
//  Endpoint+Profile.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/02.
//

import Foundation

extension Endpoint {
    static func profile(id: Int) -> Self {
        return Endpoint(path: "user/\(id)/profile/")
    }
    
    static func company(id: Int) -> Self {
        return Endpoint(path: "user/company/\(id)/")
    }
    
    static func university(id: Int) -> Self {
        return Endpoint(path: "user/university/\(id)")
    }
}
