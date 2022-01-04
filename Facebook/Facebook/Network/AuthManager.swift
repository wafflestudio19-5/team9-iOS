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
        return Observable.create { success in
            NetworkService.post(endpoint: .createUser(newUser: NewUser.shared), as: SignUpResponse.self)
                .subscribe { event in
                    // 성공
                    if event.isCompleted {
                        guard let user = event.element?.1.user, let token = event.element?.1.token else { success.onNext(false)
                            return
                        }
                        CurrentUser.shared.profile = user
                        NetworkService.registerToken(token: token)
                        success.onNext(true)
                    }
                    // 실패
                    if event.isStopEvent {
                        success.onNext(false)
                    }
                }
        }
    }
    
    // 로그인
    static func login(email: String, password: String) -> Observable<Bool> {
        return Observable.create { success in
            NetworkService.post(endpoint: .login(email: email, password: password), as: LoginResponse.self)
                .subscribe { event in
                    // 성공
                    if event.isCompleted {
                        guard let user = event.element?.1.user, let token = event.element?.1.token else { success.onNext(false)
                            return
                        }
                        CurrentUser.shared.profile = user
                        NetworkService.registerToken(token: token)
                        success.onNext(true)
                    }
                    // 실패
                    if event.isStopEvent {
                        success.onNext(false)
                    }
                }
        }
    }
}
