//
//  NetworkService.swift
//  Facebook
//
//  Created by 박신홍 on 2021/11/27.
//

import Alamofire
import RxAlamofire
import RxSwift
import UIKit

struct NetworkService {
    private static let configuration = URLSessionConfiguration.af.default
    private static var session = Session(configuration: configuration)
    private static var disposeBag = DisposeBag()
    
    static var needRefreshToken: Bool {
        guard let tokenRegisterTimestamp = UserDefaultsManager.tokenRegisterTimestamp else { return false}
        let current = NSDate().timeIntervalSince1970
        return (current - tokenRegisterTimestamp) > 60 * 60 * 24 * 2 // 이틀에 한번 씩 refresh
    }
    
    static func cancelAllRequests() {
        self.session.cancelAllRequests()
    }
    
    static func registerToken(token: String) {
        print("JWT \(token)")
        UserDefaultsManager.tokenRegisterTimestamp = NSDate().timeIntervalSince1970
        self.session = Session(configuration: configuration, interceptor: Interceptor(adapters: [JWTAdapter(token: token)]))
    }
    
    static func removeToken() {
        self.session = Session(configuration: configuration)
    }
    
    static func refreshTokenIfNeeded() {
        if !needRefreshToken {
            return
        }
        guard let token = UserDefaultsManager.token else { return }
        NetworkService.post(endpoint: .refreshToken(token: token), as: TokenResponse.self)
            .subscribe(onNext: { response in
                let newToken = response.1.token
                NetworkService.registerToken(token: newToken)
                UserDefaultsManager.token = newToken
                print("token refreshed:", newToken)
            }, onError: { _ in
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.changeRootViewController(LoginViewController(), wrap: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /*
     MARK: Basic HTTP Methods (JSON)
     */
    
    static func get(endpoint: Endpoint) -> Observable<Any> {
        return session.rx.json(.get, endpoint.url)
    }
    
    static func post(endpoint: Endpoint) -> Observable<Any> {
        return session.rx.json(.post, endpoint.url, parameters: endpoint.parameters)
    }
    
    static func put(endpoint: Endpoint) -> Observable<Any> {
        return session.rx.json(.put, endpoint.url)
    }
    
    static func delete(endpoint: Endpoint) -> Observable<Any> {
        return session.rx.json(.delete, endpoint.url)
    }
    
    /*
     MARK: Basic HTTP Methods (Object)
     */
    
    static func get<T: Decodable>(endpoint: Endpoint, as: T.Type = T.self) -> Observable<(HTTPURLResponse, T)> {
        return session.rx.responseDecodable(.get, endpoint.url)
    }
    
    static func post<T: Decodable>(endpoint: Endpoint, as: T.Type = T.self) -> Observable<(HTTPURLResponse, T)> {
        return session.rx.responseDecodable(.post, endpoint.url, parameters: endpoint.parameters, encoding: JSONEncoding.default)
    }
    
    static func put<T: Decodable>(endpoint: Endpoint, as: T.Type = T.self) -> Observable<(HTTPURLResponse, T)> {
        return session.rx.responseDecodable(.put, endpoint.url, parameters: endpoint.parameters, encoding: JSONEncoding.default)
    }
    
    static func delete<T: Decodable>(endpoint: Endpoint, as: T.Type = T.self) -> Observable<(HTTPURLResponse, T)> {
        return session.rx.responseDecodable(.delete, endpoint.url, parameters: endpoint.parameters, encoding: JSONEncoding.default)
    }
    
    /*
     MARK: Upload files
     */
    
    static func upload(endpoint: Endpoint) -> Observable<UploadRequest> {
        return session.rx.upload(multipartFormData: endpoint.multipartFormDataBuilder!, to: endpoint.url, method: .post, headers: [.contentType("multipart/form-data")])
    }
    
    static func update(endpoint: Endpoint) -> Observable<UploadRequest> {
        return session.rx.upload(multipartFormData: endpoint.multipartFormDataBuilder!, to: endpoint.url, method: .put, headers: [.contentType("multipart/form-data")])
    }
}


struct JWTAdapter: RequestInterceptor {
    private let token: String
    
    init(token: String) {
        self.token = token
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization("JWT \(self.token)"))
        completion(.success(urlRequest))
    }
}

// 필요 없을 것 같아서 일단 주석처리
//struct DefaultHeaderAdapter: RequestInterceptor {
//    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//        var urlRequest = urlRequest
////        urlRequest.headers.add(.contentType("application/json"))
//        completion(.success(urlRequest))
//    }
//}
