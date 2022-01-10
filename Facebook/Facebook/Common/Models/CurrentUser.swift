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
    
    var profile: User?
    
    func saveCurrentUser() {
        let currentUserData = try? JSONEncoder().encode(self.profile)
        UserDefaults.standard.setValue(currentUserData, forKey: "CurrentUser")
        print(self.profile?.email)
    }
    
    func getCurrentUser() {
        let data = UserDefaults.standard.value(forKey: "CurrentUser") as? Data
        let currentUserData = try? JSONDecoder().decode(User.self, from: data!)
        self.profile = currentUserData
        print(self.profile?.email)
    }
    
    func saveToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "Token")
    }
    
    func getToken() -> String {
        let token = UserDefaults.standard.value(forKey: "Token") as? String
        guard let token = token else { return "" }
        return token
    }
}
