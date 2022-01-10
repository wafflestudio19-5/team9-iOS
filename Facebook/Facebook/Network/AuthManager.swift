//
//  AuthManager.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/04.
//

import RxSwift

struct AuthManager {
    
    static let disposeBag = DisposeBag()
    
    // 회원가입
    static func signup(user: NewUser) -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.post(endpoint: .createUser(newUser: NewUser.shared), as: AuthResponse.self)
                .subscribe (onNext: { response in
                    //print(response.1.token)
                    CurrentUser.shared.profile = response.1.user
                    CurrentUser.shared.saveCurrentUser()
                    CurrentUser.shared.saveToken(token: response.1.token)
                    NetworkService.registerToken(token: response.1.token)
                    result(.success(true))
                }, onError: { _ in
                    result(.success(false))
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    // 로그인
    static func login(email: String, password: String) -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.post(endpoint: .login(email: email, password: password), as: AuthResponse.self)
                .subscribe(onNext: { response in
                    CurrentUser.shared.profile = response.1.user
                    CurrentUser.shared.saveCurrentUser()
                    CurrentUser.shared.saveToken(token: response.1.token)
                    NetworkService.registerToken(token: response.1.token)
                    result(.success(true))
                }, onError: { _ in
                    result(.success(false))
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}
