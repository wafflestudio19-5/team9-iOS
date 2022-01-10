//
//  AuthManager.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/04.
//

import RxSwift

class AuthManager {
    
    private let disposeBag = DisposeBag()
    
    static let shared = AuthManager()
    private init() { }
    
    // 회원가입
    func signup(user: NewUser) -> Single<Bool> {
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
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    // 로그인
    func login(email: String, password: String) -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.post(endpoint: .login(email: email, password: password), as: AuthResponse.self)
                .subscribe(onNext: { response in
                    CurrentUser.shared.profile = response.1.user
                    CurrentUser.shared.saveCurrentUser()
                    CurrentUser.shared.saveToken(token: response.1.token)
                    NetworkService.registerToken(token: response.1.token)
                    print(response.1.token)
                    result(.success(true))
                }, onError: { _ in
                    result(.success(false))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    // 로그아웃
    func logout() -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.get(endpoint: .logout(), as: String.self)
                .subscribe(onNext: { response in
                    print(response)
                    if response.0.statusCode == 200 { result(.success(true)) }
                }, onError: { _ in
                    result(.success(false))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
