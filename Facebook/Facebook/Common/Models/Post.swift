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
    let author: User?
    var content: String
    var likes: Int
    var is_liked: Bool
    let posted_at: String?
    var comments: Int
    let file: String?
    var scope: Scope?
    
    let mainpost: Int?
    var subposts: [Post]?
    
    static func getDummyPost() -> Self {
        return Post(id: -1, author: nil, content: "", likes: -1, is_liked: false, posted_at: nil, comments: -1, file: nil, mainpost: nil, subposts: nil)
    }
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
