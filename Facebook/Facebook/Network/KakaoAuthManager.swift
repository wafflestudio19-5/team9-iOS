//
//  KakaoAuthManager.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/29.
//

import RxSwift
import KakaoSDKUser
import RxKakaoSDKUser
import KakaoSDKAuth

struct KakaoAuthManager {
    
    private static let disposeBag = DisposeBag()
    
    enum Request {
        case connect
        case disconnect
        case login
    }
    
    static func requestKakaoLogin(type: Request) -> Observable<Bool> {
        return Observable<Bool>.create { result in
            { () -> Observable<OAuthToken> in
                if UserApi.isKakaoTalkLoginAvailable() {
                    return UserApi.shared.rx.loginWithKakaoTalk()
                } else {
                    return UserApi.shared.rx.loginWithKakaoAccount()
                }
            }().subscribe(onNext: { response in
                { () -> Single<Bool> in
                    switch type {
                    case .connect:
                        return self.connectKakaoAccount(accessToken: response.accessToken)
                    case .disconnect:
                        return self.disconnectKakaoAccount(accessToken: response.accessToken)
                    case .login:
                        return self.loginKakaoAccount(accessToken: response.accessToken)
                    }
                }().subscribe { success in
                    switch success {
                    case .success(true): result.onNext(true)
                    case .success(false): result.onNext(false)
                    case .failure(let error): result.onError(error)
                    }
                }.disposed(by: self.disposeBag)
            }, onError: { error in
                result.onError(error)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private static func connectKakaoAccount(accessToken: String) -> Single<Bool> {
        // 카카오 access token과 유저의 JWT 토큰으로 서버에 "카카오 계정 연결" 요청

        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.post(endpoint: .connectWithKakao(accessToken: accessToken), as: String.self)
                .subscribe(onNext: { response in
                    if response.0.statusCode == 201 {
                        result(.success(true))
                    }
                    else {
                        result(.success(false))
                    }
                }, onError: { error in
                    result(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private static func loginKakaoAccount(accessToken: String) -> Single<Bool> {
        // 카카오 access token으로 서버에 "카카오 계정으로 로그인" 요청
        
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.post(endpoint: .loginWithKakao(accessToken: accessToken))
                .subscribe(onNext: { response in
                    guard let response = response as? AuthResponse else {
                        result(.success(false))
                        return
                    }
                    StateManager.of.user.dispatch(authResponse: response)
                    result(.success(true))
                }, onError: { error in
                    result(.failure(error))
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    private static func disconnectKakaoAccount(accessToken: String) -> Single<Bool> {
        // 카카오 access token과 유저의 JWT 토큰으로 서버에 "카카오 계정 해제" 요청

        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.delete(endpoint: .connectWithKakao(accessToken: accessToken), as: String.self)
                .subscribe(onNext: { response in
                    if response.0.statusCode == 200 {
                        result(.success(true))
                    } else {
                        result(.success(false))
                    }
                }, onError: { error in
                    result(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
