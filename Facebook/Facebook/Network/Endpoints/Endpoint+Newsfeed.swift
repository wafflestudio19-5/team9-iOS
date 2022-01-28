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
    
    static func newsfeed(content: String, files: [Data] = [], subcontents: [String] = [], scope: Scope = .all, sharing postId: Int? = nil) -> Self {
        assert(files.count == subcontents.count, "파일 개수와 캡션의 개수는 일치해야합니다.")
        let filesCount = files.count
        let builder: (MultipartFormData) -> Void = { formData in
            // content를 추가
            formData.append(content.data(using: .utf8)!, withName: "content")
            formData.append(scope.rawValue.description.data(using: .utf8)!, withName: "scope")
            if let shareId = postId {
                formData.append(shareId.description.data(using: .utf8)!, withName: "shared_post")
            }
            
            // subcontents의 내용을 추가
            for subcontent in subcontents {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: ["content": subcontent], options: .prettyPrinted) else { continue }
                formData.append(jsonData, withName: "subposts")
            }
            
            // 각 file을 추가
            for i in 0..<filesCount {
                formData.append(files[i], withName: "file", fileName: "\(Date().timeIntervalSince1970).jpeg" , mimeType: "image/jpeg")
            }
        }
        return Endpoint(path: "newsfeed/", multipartFormDataBuilder: builder)
    }
    
    static func newsfeed(editing post: Post, subposts: [SubPost], removed_subposts: [Int] = []) -> Self {
        
        let builder: (MultipartFormData) -> Void = { formData in
            // content를 추가
            formData.append(post.content.data(using: .utf8)!, withName: "content")
            formData.append((post.scope?.rawValue ?? 1).description.data(using: .utf8)!, withName: "scope")
            print("scope", post.scope?.rawValue ?? 1)
            
            for subpost in subposts {
                guard let subpostId = subpost.id else { continue }
                guard let jsonData = try? JSONSerialization.data(withJSONObject: ["id": subpostId, "content": subpost.content ?? ""]) else { continue }
                formData.append(jsonData, withName: "subposts")
            }
            
            // 추가되는 이미지
            let files = subposts.map {$0.data}.compactMap{$0}
            let subcontents = subposts.map {$0.data != nil ? $0.content ?? "" : nil}.compactMap{$0}
            assert(files.count == subcontents.count)
            for i in 0..<files.count {
                formData.append(files[i], withName: "file", fileName: "\(Date().timeIntervalSince1970).jpeg" , mimeType: "image/jpeg")
            }
            for subcontent in subcontents {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: ["content": subcontent], options: .prettyPrinted) else { continue }
                formData.append(jsonData, withName: "new_subposts")
            }
            
            for removedId in removed_subposts {
                formData.append(removedId.description.data(using: .utf8)!, withName: "removed_subposts")
            }
        }
        return Endpoint(path: "newsfeed/\(post.id)/", multipartFormDataBuilder: builder)
    }
    
    static func newsfeed(postId: Int) -> Self {
        return Endpoint(path: "newsfeed/\(postId)/")
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
    
    static func commentUpdate(postId: Int, commentId: Int, content: String) -> Self {
        let builder: (MultipartFormData) -> Void = { formData in
            formData.append(content.data(using: .utf8)!, withName: "content")
        }
        return Endpoint(path: "newsfeed/\(postId)/\(commentId)/", multipartFormDataBuilder: builder)
    }
    
    static func commentDelete(postId: Int, commentId: Int) -> Self {
        return Endpoint(path: "newsfeed/\(postId)/\(commentId)/")
    }
}
