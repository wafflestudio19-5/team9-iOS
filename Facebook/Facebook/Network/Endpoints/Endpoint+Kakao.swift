//
//  Endpoint+Kakao.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/07.
//

import Foundation

extension Endpoint {
    static func loginWithKakao(accessToken: String) -> Self {
        return Endpoint(path: "kakao/login/", parameters: ["access_token": accessToken])
    }
    
    // JWT 토큰 필요
    static func connectWithKakao(accessToken: String) -> Self {
        return Endpoint(path: "kakao/connect/", parameters: ["access_token": accessToken])
    }
}
