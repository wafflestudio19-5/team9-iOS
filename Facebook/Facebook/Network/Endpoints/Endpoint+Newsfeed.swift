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
    
    static func newsfeed(userId: Int, cursor: String? = nil) -> Self {
        return Endpoint(path: "user/\(userId)/newsfeed/", cursor: cursor)
    }
    
    static func newsfeed(content: String, files: [Data] = [], subcontents: [String] = [], scope: Scope = .all) -> Self {
        assert(files.count == subcontents.count, "파일 개수와 캡션의 개수는 일치해야합니다.")
        let filesCount = files.count
        let builder: (MultipartFormData) -> Void = { formData in
            // content를 추가
            formData.append(content.data(using: .utf8)!, withName: "content")
            formData.append(scope.rawValue.description.data(using: .utf8)!, withName: "scope")
            
            // subcontents의 내용을 추가
            for subcontent in subcontents {
                formData.append(subcontent.data(using: .utf8)!, withName: "subposts")
            }
            
            // 각 file을 추가
            for i in 0..<filesCount {
                formData.append(files[i], withName: "file", fileName: "\(Date().timeIntervalSince1970).jpeg" , mimeType: "image/jpeg")
            }
        }
        return Endpoint(path: "newsfeed/", multipartFormDataBuilder: builder)
    }
    
    static func newsfeedLike(postId: Int) -> Self {
        return Endpoint(path: "newsfeed/\(postId)/like/")
    }
    
    static func comment(postId: Int, cursor: String? = nil) -> Self {
        return Endpoint(path: "newsfeed/\(postId)/comment/", cursor: cursor)
    }
    
    static func comment(postId: Int, to parentId: Int?, content: String) -> Self {
        let builder: (MultipartFormData) -> Void = { formData in
            formData.append(content.data(using: .utf8)!, withName: "content")
            if let parentId = parentId {
                formData.append(parentId.description.data(using: .utf8)!, withName: "parent")
            }
        }
        return Endpoint(path: "newsfeed/\(postId)/comment/", multipartFormDataBuilder: builder)
    }
    
    static func commentLike(postId: Int, commentId: Int) -> Self {
        return Endpoint(path: "newsfeed/\(postId)/\(commentId)/like/")
    }
}
