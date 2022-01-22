//
//  Post.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/16.
//

import Foundation
import UIKit


struct Post: Codable, Identifiable {
    let id: Int
    var author: User?
    var content: String
    var likes: Int
    var is_liked: Bool
    var posted_at: String?
    var comments: Int
    var file: String?
    var scope: Scope?
    
    let mainpost: Int?
    var subposts: [Post]?
    
    var shared_post: SharedPost?
    var is_sharing: Bool?
    var sharing_counts: Int?
    
    static func getDummyPost() -> Self {
        return Post(id: -1, content: "", likes: -1, is_liked: false, comments: -1, mainpost: nil)
    }
    
    /// 이 `Post`를 공유하고자 할 때, `shared_post`가 존재하면 이 `Post`가 아닌 `shared_post`를 공유한다.
    var postToShare: Post {
        if let shared_post = shared_post {
            return Post(id: shared_post.id, author: shared_post.author, content: shared_post.content, likes: -1, is_liked: false, posted_at: shared_post.posted_at, comments: -1, scope: shared_post.scope, mainpost: nil, subposts: shared_post.subposts)
        } else {
            return self
        }
    }
    
    var subpostUrls: [URL?] {
        return self.subposts?.map {
            guard let urlString = $0.file, let url = URL(string: urlString) else { return nil }
            return url
        } ?? []
    }
}

struct SharedPost: Codable, Identifiable {
    let id: Int
    var author: User
    var content: String
    var posted_at: String
    var scope: Scope
    var subposts: [Post]
}

enum Scope: Int, Codable, CaseIterable {
    case all = 3
    case friends = 2
    case secret = 1
    
    var symbolName: String {
        switch self {
        case .all:
            return "globe.asia.australia"
        case .friends:
            return "person.2"
        case .secret:
            return "lock"
        }
    }
    
    var text: String {
        switch self {
        case .all:
            return "전체 공개"
        case .friends:
            return "친구만"
        case .secret:
            return "나만 보기"
        }
    }
    
    func getImage(fill: Bool, color: UIColor = .grayscales.label.withAlphaComponent(0.7), size: CGFloat = 10) -> UIImage {
        let imageName = fill ? symbolName + ".fill" : symbolName
        return UIImage(systemName: imageName)!.withTintColor(color, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: size, weight: .regular))
    }
}
