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
    
    static func profile(id: Int, userProfile: UserProfile) -> Self {
        return Endpoint(path: "user/\(id)/profile/",
                        parameters: ["first_name": userProfile.first_name,
                                     "last_name": userProfile.last_name,
                                     "birth": userProfile.birth,
                                     "gender": userProfile.gender,
                                     "self_intro": (userProfile.self_intro != nil && userProfile.self_intro != "" ) ? userProfile.self_intro! : ""])
    }
    
    static func company(id: Int) -> Self {
        return Endpoint(path: "user/company/\(id)/")
    }
    
    static func company(company: Company) -> Self {
        return Endpoint(path: "user/company/",
                        parameters: [ : ])
    }
    
    static func company(id: Int, company: Company) -> Self {
        return Endpoint(path: "user/company/\(id)/",
                        parameters: [ : ])
    }
    
    static func university(id: Int) -> Self {
        return Endpoint(path: "user/university/\(id)")
    }
    
    static func university(university: University) -> Self {
        return Endpoint(path: "user/university/",
                        parameters: [ : ])
    }
    
    static func university(id: Int, university: University) -> Self {
        return Endpoint(path: "user/university/\(id)/",
                        parameters: [ : ])
    }
    
}
