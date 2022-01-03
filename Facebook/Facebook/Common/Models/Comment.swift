//
//  Comment.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/03.
//

import Foundation


struct Comment: Codable, Identifiable {
    let id: Int
    let author: User
    let content: String
    let file: String?
    let likes: String
}
