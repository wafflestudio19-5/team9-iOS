//
//  Endpoint+Account.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/17.
//

import Foundation

extension Endpoint {
    static func login(email: String, password: String) -> Self {
        return Endpoint(path: "account/login/", parameters: ["email": email, "password": password])
    }
    
    static func logout() -> Self {
        return Endpoint(path: "account/logout/")
    }
    
    static func loginWithKakao(accessToken: String) -> Self {
        return Endpoint(path: "account/kakao/login/", parameters: ["access_token": accessToken])
    }
    
    static func connectWithKakao(accessToken: String) -> Self {
        return Endpoint(path: "account/kakao/connect/", parameters: ["access_token": accessToken])
    }
    
    static func createUser(newUser: NewUser) -> Self {
        return Endpoint(path: "account/signup/", parameters: ["email": newUser.email!, "first_name": newUser.first_name!, "last_name": newUser.last_name!, "birth": newUser.birth!, "gender": newUser.gender!, "password": newUser.password!])
    }
    
    static func refreshToken(token: String) -> Self {
        return Endpoint(path: "token/refresh/", parameters: ["token": token])

    static func deleteAccount() -> Self {
        return Endpoint(path: "account/delete/")
    }

    static func refreshToken(token: String) -> Self {
        return Endpoint(path: "token/refresh/", parameters: ["token": token])
    }
}
