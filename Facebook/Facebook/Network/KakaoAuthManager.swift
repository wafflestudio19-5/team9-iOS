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

class KakaoAuthManager {
    
    private let disposeBag = DisposeBag()
    
    static let shared = KakaoAuthManager()
    private init() { }
    
    enum Request {
        case connect
        case disconnect
        case login
    }
    
    func requestKakaoLogin(type: Request) -> Observable<Bool> {
        return Observable<Bool>.create { result in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe(onNext: { [weak self] response in
                        guard let self = self else { return }
                        
                        switch type {
                        case .connect:
                            self.connectKakaoAccount(accessToken: response.accessToken)
                                .subscribe { success in
                                    switch success {
                                    case .success(true): result.onNext(true)
                                    case .success(false): result.onNext(false)
                                    case .failure(let error): result.onError(error)
                                    }
                                }.disposed(by: self.disposeBag)
                        case .disconnect:
                            self.disconnectKakaoAccount(accessToken: response.accessToken)
                                .subscribe { success in
                                    switch success {
                                    case .success(true): result.onNext(true)
                                    case .success(false): result.onNext(false)
                                    case .failure(let error): result.onError(error)
                                    }
                                }.disposed(by: self.disposeBag)
                        case .login:
                            self.loginKakaoAccount(accessToken: response.accessToken)
                                .subscribe { success in
                                    switch success {
                                    case .success(true): result.onNext(true)
                                    case .success(false): result.onNext(false)
                                    case .failure(let error): result.onError(error)
                                    }
                                }.disposed(by: self.disposeBag)
                        }
                    }, onError: { error in
                        result.onError(error)
                    }).disposed(by: self.disposeBag)
            } else {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe(onNext: { [weak self] response in
                        guard let self = self else { return }
                        
                        switch type {
                        case .connect:
                            self.connectKakaoAccount(accessToken: response.accessToken)
                                .subscribe { success in
                                    switch success {
                                    case .success(true): result.onNext(true)
                                    case .success(false): result.onNext(false)
                                    case .failure(let error): result.onError(error)
                                    }
                                }.disposed(by: self.disposeBag)
                        case .disconnect:
                            self.disconnectKakaoAccount(accessToken: response.accessToken)
                                .subscribe { success in
                                    switch success {
                                    case .success(true): result.onNext(true)
                                    default: result.onNext(false)
                                    }
                                }.disposed(by: self.disposeBag)
                        case .login:
                            self.loginKakaoAccount(accessToken: response.accessToken)
                                .subscribe { success in
                                    switch success {
                                    case .success(true): print("성공!!")
                                        result.onNext(true)
                                    default: result.onNext(false)
                                    }
                                }.disposed(by: self.disposeBag)
                        }
                    }, onError: { error in
                        result.onError(error)
                    }).disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }
    
    private func connectKakaoAccount(accessToken: String) -> Single<Bool> {
        // 카카오 access token과 유저의 JWT 토큰으로 서버에 "카카오 계정 연결" 요청

        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.post(endpoint: .connectWithKakao(accessToken: accessToken), as: String.self)
                .subscribe(onNext: { response in
                    if response.0.statusCode == 201 { result(.success(true)) }
                    else { result(.success(false)) }
                }, onError: { error in
                    result(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func loginKakaoAccount(accessToken: String) -> Single<Bool> {
        // 카카오 access token으로 서버에 "카카오 계정으로 로그인" 요청
        
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.post(endpoint: .loginWithKakao(accessToken: accessToken), as: AuthResponse.self)
                .subscribe(onNext: { response in
                    //print(response.1.token)
                    if response.0.statusCode == 200 {
                        CurrentUser.shared.profile = response.1.user
                        CurrentUser.shared.saveCurrentUser()
                        CurrentUser.shared.saveToken(token: response.1.token)
                        NetworkService.registerToken(token: response.1.token)
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
    
    private func disconnectKakaoAccount(accessToken: String) -> Single<Bool> {
        // 카카오 access token과 유저의 JWT 토큰으로 서버에 "카카오 계정 해제" 요청

        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.delete(endpoint: .connectWithKakao(accessToken: accessToken), as: String?.self)
                .subscribe(onNext: { response in
                    if response.0.statusCode == 204 {
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
