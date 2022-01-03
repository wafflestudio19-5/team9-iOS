//
//  Endpoint+NewUser.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/29.
//

import Foundation

extension Endpoint {
    static func createUser(newUser: NewUser) -> Self {
        return Endpoint(path: "signup/", parameters: ["email": newUser.email!, "first_name": newUser.first_name!, "last_name": newUser.last_name!, "birth": newUser.birth!, "gender": newUser.gender!, "password": newUser.password!])
    }
}
