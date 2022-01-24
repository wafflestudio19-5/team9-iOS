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
    private let profileDataSource = BehaviorRelay<UserProfile>(value: UserProfile.getDummyProfile())
    
    override init() {
        super.init()
        self.bind(with: profileDataSource).disposed(by: disposeBag)
    }
    
    var profile: UserProfile {
        profileDataSource.value
    }
    
    func asObservable() -> Observable<UserProfile> {
        return profileDataSource.asObservable()
    }
    
    func dispatch(authResponse: AuthResponse) {
        UserDefaultsManager.token = authResponse.token
        UserDefaultsManager.cachedUser = authResponse.user
        UserDefaultsManager.isLoggedIn = true
        UserDefaultsManager.isValid = authResponse.user.is_valid
        NetworkService.registerToken(token: authResponse.token)
        profileDataSource.accept(UserProfile.getDummyProfile(from: authResponse.user))
    }
    
    func dispatch(profile: UserProfile) {
        profileDataSource.accept(profile)
    }
    
    func dispatch(cachedUser: User) {
        profileDataSource.accept(UserProfile.getDummyProfile(from: cachedUser))
    }
}
