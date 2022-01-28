//
//  FriendDispatcher.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/28.
//

import Foundation
import RxSwift
import RxRelay

struct FriendRelationInfo {
    let id: Int
    let friend_info: String
}

class FriendDispatcher: Dispatcher<User> {
    private let friendInfoChangeObserver = BehaviorRelay<FriendRelationInfo>(value: FriendRelationInfo(id: -1, friend_info: "nothing"))
    
    func asObservable() -> Observable<FriendRelationInfo> {
        return friendInfoChangeObserver.asObservable()
    }
    
    
    func dispatch(delete friend: User) {
        var friend = friend
        friend.friend_info = "nothing"
        friendInfoChangeObserver.accept(FriendRelationInfo(id: friend.id, friend_info: "nothing"))
        dispatchedSignals.accept(.init(data: friend, operation: .edit))
    }
    
    func dispatch(sent friend: User) {
        var friend = friend
        friend.friend_info = "sent"
        friendInfoChangeObserver.accept(FriendRelationInfo(id: friend.id, friend_info: "sent"))
        dispatchedSignals.accept(.init(data: friend, operation: .edit))
    }
    
    func dispatch(accept friend: User) {
        var friend = friend
        friend.friend_info = "friend"
        friendInfoChangeObserver.accept(FriendRelationInfo(id: friend.id, friend_info: "friend"))
        dispatchedSignals.accept(.init(data: friend, operation: .edit))
    }
}
