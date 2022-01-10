//
//  UserDispatcher.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/09.
//

import Foundation
import RxSwift
import RxRelay

/// 자기 자신의 상태를 관리한다.
struct UserDefaultsManager {
    
    private static let userKey = "CurrentUser"
    private static let tokenKey = "Token"
    private static let isLoggedInKey = "isLoggedIn"
    
    static var isLoggedIn: Bool {
        get {
            guard let isLoggedIn = UserDefaults.standard.value(forKey: isLoggedInKey) as? Bool else { return false }
            return isLoggedIn
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: isLoggedInKey)
        }
    }
    
    static var token: String? {
        get {
            return UserDefaults.standard.value(forKey: tokenKey) as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: tokenKey)
        }
    }
    
    static var cachedUser: User? {
        get {
            let data = UserDefaults.standard.value(forKey: self.userKey) as? Data
            return try? JSONDecoder().decode(User.self, from: data!)
        }
        set {
            let currentUserData = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.setValue(currentUserData, forKey: self.userKey)
        }
    }
}
