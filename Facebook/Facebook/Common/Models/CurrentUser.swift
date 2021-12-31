//
//  CurrentUser.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/31.
//

import Foundation

class CurrentUser {
    
    static let shared = CurrentUser()
    
    private init() { }
    
    var id: Int?
    var email: String?
    var username: String?
    var profile_image: String?
    
    
}
