//
//  FriendDispatcher.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/28.
//

import Foundation
import RxSwift
import RxRelay

struct FriendInfoChange {
    let id: Int
    let friend_info: String
}

class FriendDispatcher: Dispatcher<User> {
    private let friendInfoChange = BehaviorRelay<FriendInfoChange>(value: FriendInfoChange(id: -1, friend_info: "nothing"))
    
    func asObservable() -> Observable<FriendInfoChange> {
        return friendInfoChange.asObservable()
    }
    
    
    func dispatch(delete friend: User) {
        var friend = friend
        friend.friend_info = "nothing"
        friendInfoChange.accept(FriendInfoChange(id: friend.id, friend_info: "nothing"))
        dispatchedSignals.accept(.init(data: friend, operation: .edit))
    }
    
    func dispatch(sent friend: User) {
        var friend = friend
        friend.friend_info = "sent"
        friendInfoChange.accept(FriendInfoChange(id: friend.id, friend_info: "sent"))
        dispatchedSignals.accept(.init(data: friend, operation: .edit))
    }
}
