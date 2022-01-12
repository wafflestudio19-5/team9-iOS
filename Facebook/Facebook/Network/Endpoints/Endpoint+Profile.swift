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
    
    static func profile(id: Int ,updateData: [String: Any]) -> Self {
        let multipartFormDataBuilder: (MultipartFormData) -> Void = { multipartFormData in
            for (key, value) in updateData {
                if let value = value as? String {
                    //텍스트 형식의 데이터
                    multipartFormData.append(value.data(using: .utf8) ?? Data(), withName: "\(key)")
                } else if let value = value as? Data {
                    //이미지 형식의 데이터
                    multipartFormData.append(value, withName: "\(key)", fileName: "\(Date().timeIntervalSince1970).jpeg" , mimeType: "image/jpeg")
                }
            }
        }
        
        return Endpoint(path: "user/\(id)/profile/", multipartFormDataBuilder: multipartFormDataBuilder)
    }
    
    static func company(id: Int) -> Self {
        return Endpoint(path: "user/company/\(id)/")
    }
    
    static func company(company: Company) -> Self {
        if company.is_active! == true {
            return Endpoint(path: "user/company/",
                            parameters: ["user": CurrentUser.shared.profile?.id ?? 0,
                                         "name": company.name ?? "",
                                         "role": company.role ?? "",
                                         "location": company.location ?? "" ,
                                         "join_date": company.join_date ?? "",
                                         "detail": company.detail ?? ""])
        } else {
            return Endpoint(path: "user/company/",
                            parameters: ["user": CurrentUser.shared.profile?.id ?? 0,
                                         "name": company.name ?? "",
                                         "role": company.role ?? "",
                                         "location": company.location ?? "" ,
                                         "join_date": company.join_date ?? "",
                                         "leave_date": company.leave_date ?? "",
                                         "detail": company.detail ?? ""])
        }
    }
    
    static func company(id: Int, company: Company) -> Self {
        if company.is_active! == true {
            return Endpoint(path: "user/company/\(id)/",
                            parameters: ["user": CurrentUser.shared.profile?.id ?? 0,
                                         "name": company.name ?? "",
                                         "role": company.role ?? "",
                                         "location": company.location ?? "" ,
                                         "join_date": company.join_date ?? "",
                                         "leave_date": "",
                                         "detail": company.detail ?? ""])
        } else {
            return Endpoint(path: "user/company/\(id)/",
                            parameters: ["user": CurrentUser.shared.profile?.id ?? 0,
                                         "name": company.name ?? "",
                                         "role": company.role ?? "",
                                         "location": company.location ?? "" ,
                                         "join_date": company.join_date ?? "",
                                         "leave_date": company.leave_date ?? "",
                                         "detail": company.detail ?? ""])
        }
    }
    
    static func university(id: Int) -> Self {
        return Endpoint(path: "user/university/\(id)/")
    }
    
    static func university(university: University) -> Self {
        if university.is_active! == true {
            return Endpoint(path: "user/university/",
                            parameters: ["user": CurrentUser.shared.profile?.id ?? 0,
                                         "name": university.name ?? "",
                                         "major": university.major ?? "" ,
                                         "join_date": university.join_date ?? ""])
        } else {
            return Endpoint(path: "user/university/",
                            parameters: ["user": CurrentUser.shared.profile?.id ?? 0,
                                         "name": university.name ?? "",
                                         "major": university.major ?? "" ,
                                         "join_date": university.join_date ?? "",
                                         "graduate_date": university.graduate_date ?? ""])
        }
    }
    
    static func university(id: Int, university: University) -> Self {
        if university.is_active! == true {
            return Endpoint(path: "user/university/\(id)/",
                            parameters: ["user": CurrentUser.shared.profile?.id ?? 0,
                                         "name": university.name ?? "",
                                         "major": university.major ?? "" ,
                                         "join_date": university.join_date ?? "",
                                         "graduate_date": ""])
        } else {
            return Endpoint(path: "user/university/\(id)/",
                            parameters: ["user": CurrentUser.shared.profile?.id ?? 0,
                                         "name": university.name ?? "",
                                         "major": university.major ?? "" ,
                                         "join_date": university.join_date ?? "",
                                         "graduate_date": university.graduate_date ?? ""])
        }
    }
    
}
