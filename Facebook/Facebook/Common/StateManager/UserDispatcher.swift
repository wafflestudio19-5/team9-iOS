//
//  UserDispatcher.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/09.
//

import Foundation
import RxSwift
import RxRelay

/// 자기 자신의 상태를 관리한다.
class UserDispatcher: Dispatcher<UserProfile> {
    private let disposeBag = DisposeBag()
    let asObservable = BehaviorRelay<UserProfile>(value: UserProfile.getDummyProfile())
    
    override init() {
        super.init()
        self.bind(with: asObservable).disposed(by: disposeBag)
    }
    
    var profile: UserProfile {
        asObservable.value
    }
    
    func dispatch(authResponse: AuthResponse) {
        UserDefaultManager.token = authResponse.token
        UserDefaultManager.cachedUser = authResponse.user
        UserDefaultManager.isLoggedIn = true
        NetworkService.registerToken(token: authResponse.token)
        asObservable.accept(UserProfile.getDummyProfile(from: authResponse.user))
    }
    
    func dispatch(cachedUser: Author) {
        asObservable.accept(UserProfile.getDummyProfile(from: cachedUser))
    }
}
