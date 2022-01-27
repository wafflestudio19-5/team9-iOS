//
//  FriendRequestManager.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/27.
//

import RxSwift

/// 친구 요청과 관련된 연결을 관리
struct FriendRequestManager {
    
    static let disposeBag = DisposeBag()
    
    /// 친구 요청 수락: 성공할 경우 onCompleted, 실패할 경우 onError이 수행됩니다.
    static func acceptRequest(from id: Int) -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.put(endpoint: .friendRequest(id: id), as: String.self)
                .subscribe (onError: { _ in
                    result(.success(false))
                }, onCompleted: {
                    result(.success(true))
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    /// 친구 요청 삭제: 성공할 경우 onCompleted, 실패할 경우 onError이 수행됩니다.
    static func deleteRequest(from id: Int) -> Single<Bool> {
        return Single<Bool>.create { (result) -> Disposable in
            NetworkService.delete(endpoint: .friendRequest(id: id))
                .subscribe (onError: { _ in
                    result(.success(false))
                }, onCompleted: {
                    result(.success(true))
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}
