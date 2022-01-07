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
    
    func requestKakaoLogin() -> Observable<Bool> {
        return Observable<Bool>.create { result in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe(onNext: { response in
                        result.onNext(true)
                    }, onError: { _ in
                        result.onNext(false)
                    }).disposed(by: self.disposeBag)
            } else {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe(onNext: { _ in
                        result.onNext(true)
                    }, onError: { _ in
                        result.onNext(false)
                    }).disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }
    
    func connectKakaoAccount(accessToken: String, userToken: String) {
        // 카카오 access token과 유저의 JWT 토큰으로 서버에 "카카오 계정 연결" 요청
    }
    
    func loginKakaoAccount(accessToken: String) {
        // 카카오 access token으로 서버에 "카카오 계정으로 로그인" 요청
    }
}
