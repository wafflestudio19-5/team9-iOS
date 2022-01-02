//
//  NewUser.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/24.
//

import Foundation

class NewUser: Codable {
    
    static let shared = NewUser()
    
    private init() { }
    
    var email: String?
    var first_name: String?
    var last_name: String?
    var birth: String?
    var gender: String?
    var password: String?
    
    func reset() {
        self.email = ""
        self.first_name = ""
        self.last_name = ""
        self.birth = ""
        self.gender = ""
        self.password = ""
    }
}
