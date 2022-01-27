//
//  AuthManager.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/04.
//

import RxSwift

struct AuthManager {
    
    static let disposeBag = DisposeBag()
    
    /// 회원가입
    static func signup(user: NewUser) -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.post(endpoint: .createUser(newUser: NewUser.shared), as: AuthResponse.self)
                .subscribe (onNext: { response in
                    StateManager.of.user.dispatch(authResponse: response.1)
                    result(.success(true))
                }, onError: { _ in
                    result(.success(false))
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    /// 회원탈퇴
    static func delete() -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.delete(endpoint: .deleteAccount())
                .subscribe (onNext: { response in
                    NetworkService.removeToken()
                    result(.success(true))
                }, onError: { _ in
                    result(.success(false))
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    /// 로그인
    static func login(email: String, password: String) -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.post(endpoint: .login(email: email, password: password), as: AuthResponse.self)
                .subscribe(onNext: { response in
                    print(response)
                    StateManager.of.user.dispatch(authResponse: response.1)
                    result(.success(true))
                }, onError: { _ in
                    result(.success(false))
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    /// 로그아웃
    static func logout() -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.get(endpoint: .logout(), as: String.self)
                .subscribe(onNext: { response in
                    if response.0.statusCode == 200 {
                        NetworkService.removeToken()
                        result(.success(true))
                    }
                }, onError: { _ in
                    result(.success(false))
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    /// 계정 활성화 여부를 확인합니다. 응답으로 token은 제외된 User형을 받아옵니다.
    static func check() -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.get(endpoint: .checkAccountStatus(token: UserDefaultsManager.token!), as: User.self)
                .subscribe(onNext: { response in
                    if let isValid = response.1.is_valid, isValid {
                        StateManager.of.user.dispatch(isValid: isValid)
                        result(.success(true))
                    } else {
                        result(.success(false))
                    }
                }, onError: { _ in
                    result(.success(false))
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}
