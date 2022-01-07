//
//  AuthManager.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/04.
//

import RxSwift

struct AuthManager {
    
    // 회원가입
    static func signup(user: NewUser) -> Observable<Bool> {
        return Observable.create { isSuccess in
            NetworkService.post(endpoint: .createUser(newUser: NewUser.shared), as: AuthResponse.self)
                .subscribe { event in
                    guard let response = event.element?.1 else {
                        isSuccess.onNext(false)
                        return
                    }
                    CurrentUser.shared.profile = response.user
                    NetworkService.registerToken(token: response.token)
                    isSuccess.onNext(true)
                }
        }
    }
    
    // 로그인
    static func login(email: String, password: String) -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.post(endpoint: .login(email: email, password: password), as: AuthResponse.self)
                .subscribe(onNext: { event in
                    let response = event.1
                    CurrentUser.shared.profile = response.user
                    NetworkService.registerToken(token: response.token)
                    result(.success(true))
                }, onError: { _ in
                    result(.success(false))
                })
        }
    }
}
