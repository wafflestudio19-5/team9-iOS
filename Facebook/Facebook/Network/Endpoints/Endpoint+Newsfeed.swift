//
//  Newsfeed.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/16.
//

import Foundation
import Alamofire
import SwiftUI

extension Endpoint {
    static func newsfeed(cursor: String? = nil) -> Self {
        return Endpoint(path: "newsfeed/", cursor: cursor)
    }
    
    static func newsfeed(content: String, files: [Data] = [], subcontents: [String] = []) -> Self {
        assert(files.count == subcontents.count, "파일 개수와 캡션의 개수는 일치해야합니다.")
        let filesCount = files.count
        let multipartFormDataBuilder: (MultipartFormData) -> Void = { multipartFormData in
            // content를 추가
            multipartFormData.append(content.data(using: .utf8)!, withName: "content")
            
            // subcontents의 내용을 추가
            for subcontent in subcontents {
                multipartFormData.append(subcontent.data(using: .utf8)!, withName: "subposts")
            }
            
            // 각 file을 추가
            for i in 0..<filesCount {
                multipartFormData.append(files[i], withName: "file", fileName: "\(Date().timeIntervalSince1970).jpeg" , mimeType: "image/jpeg")
            }
        }
        return Endpoint(path: "newsfeed/", multipartFormDataBuilder: multipartFormDataBuilder)
    }
    
    static func newsfeedLike(postId: Int) -> Self {
        return Endpoint(path: "newsfeed/\(postId)/like/")
    }
    
    static func comment(postId: Int, cursor: String? = nil) -> Self {
        return Endpoint(path: "newsfeed/\(postId)/comment/", cursor: cursor)
    }
}
