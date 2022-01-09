//
//  StateManager.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/09.
//

import Foundation

class StateManager {
    static let of = StateManager()
    
    let post = PostDispatcher()
    let user = UserDispatcher()
    let comment = CommentDispatcher()
}
