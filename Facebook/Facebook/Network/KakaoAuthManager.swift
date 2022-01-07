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
                                    if let success = success.element {
                                        result.onNext(success ? true : false)
                                    }
                                }.disposed(by: self.disposeBag)
                            return
                        case .login:
                            self.loginKakaoAccount(accessToken: response.accessToken)
                                .subscribe { success in
                                    if let success = success.element {
                                        result.onNext(success ? true : false)
                                    }
                                }.disposed(by: self.disposeBag)
                        }
                    }, onError: { _ in
                        result.onNext(false)
                    }).disposed(by: self.disposeBag)
            } else {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe(onNext: { [weak self] response in
                        guard let self = self else { return }
                        
                        switch type {
                        case .connect:
                            self.connectKakaoAccount(accessToken: response.accessToken)
                                .subscribe { success in
                                    if let success = success.element {
                                        result.onNext(success ? true : false)
                                    }
                                }.disposed(by: self.disposeBag)
                            return
                        case .login:
                            self.loginKakaoAccount(accessToken: response.accessToken)
                                .subscribe { success in
                                    if let success = success.element {
                                        result.onNext(success ? true : false)
                                    }
                                }.disposed(by: self.disposeBag)
                        }
                    }, onError: { _ in
                        result.onNext(false)
                    }).disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }
    
    private func connectKakaoAccount(accessToken: String) -> Observable<Bool> {
        // 카카오 access token과 유저의 JWT 토큰으로 서버에 "카카오 계정 연결" 요청
        // 성공하면 String 메시지만 반환됨
        
        print("\ntrying to connect....\n")
        return Observable<Bool>.create { result in
            NetworkService.post(endpoint: .connectWithKakao(accessToken: accessToken), as: String.self)
                .subscribe { response in
                    guard let status = response.element?.0.statusCode else { return }
                    if status == 201 {
                        print("NetworkService 성공")
                        result.onNext(true)
                    } else {
                        print("NetworkService 실패")
                        result.onNext(false)
                    }
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func loginKakaoAccount(accessToken: String) -> Observable<Bool> {
        // 카카오 access token으로 서버에 "카카오 계정으로 로그인" 요청
        
        print("\ntrying to login....\n")
        return Observable<Bool>.create { result in
            NetworkService.post(endpoint: .loginWithKakao(accessToken: accessToken), as: AuthResponse.self)
                .subscribe { response in
                    guard let response = response.element?.1 else {
                        result.onNext(false)
                        return
                    }
                    CurrentUser.shared.profile = response.user
                    NetworkService.registerToken(token: response.token)
                    result.onNext(true)
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
