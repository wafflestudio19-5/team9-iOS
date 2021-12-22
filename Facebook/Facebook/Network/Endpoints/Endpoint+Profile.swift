//
//  Endpoint+Profile.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/02.
//

import Foundation
import Alamofire
import simd

extension Endpoint {
    static func profile(id: Int) -> Self {
        return Endpoint(path: "user/\(id)/profile/")
    }
    
    static func profile(id: Int, userProfile: UserProfile) -> Self {
        let multipartFormDataBuilder: (MultipartFormData) -> Void = { multipartFormData in
            
        }
        return Endpoint(path: "user/\(id)/profile/", multipartFormDataBuilder: multipartFormDataBuilder)
    }
    
    static func profile(id: Int ,updateData: [String: Any]) -> Self {
        let multipartFormDataBuilder: (MultipartFormData) -> Void = { multipartFormData in
            for (key, value) in updateData {
                if value is String{
                    //텍스트 형식의 데이터
                    multipartFormData.append((value as! String).data(using: .utf8) ?? Data(), withName: "\(key)")
                } else {
                    //이미지 형식의 데이터
                    multipartFormData.append(value as! Data, withName: "\(key)", fileName: "\(Date().timeIntervalSince1970).jpeg" , mimeType: "image/jpeg")
                }
            }
        }
        
        return Endpoint(path: "user/\(id)/profile/", multipartFormDataBuilder: multipartFormDataBuilder)
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
