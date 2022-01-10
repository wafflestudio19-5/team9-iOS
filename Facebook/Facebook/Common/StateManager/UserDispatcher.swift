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
        UserDefaultsManager.token = authResponse.token
        UserDefaultsManager.cachedUser = authResponse.user
        UserDefaultsManager.isLoggedIn = true
        NetworkService.registerToken(token: authResponse.token)
        asObservable.accept(UserProfile.getDummyProfile(from: authResponse.user))
    }
    
    func dispatch(cachedUser: User) {
        asObservable.accept(UserProfile.getDummyProfile(from: cachedUser))
    }
}
