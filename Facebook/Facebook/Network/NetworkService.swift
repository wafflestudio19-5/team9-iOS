//
//  NetworkService.swift
//  Facebook
//
//  Created by 박신홍 on 2021/11/27.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import UIKit


struct NetworkService {
    private static let configuration = URLSessionConfiguration.af.default
    private static var session = Session(configuration: configuration)
    
    static func cancelAllRequests() {
        self.session.cancelAllRequests()
    }
    
    static func registerToken(token: String) {
        print(token)
        self.session = Session(configuration: configuration, interceptor: Interceptor(adapters: [JWTAdapter(token: token)]))
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
    
    /*
     MARK: Upload files
     */
    
    static func upload(endpoint: Endpoint) -> Observable<UploadRequest> {
        return session.rx.upload(multipartFormData: endpoint.multipartFormDataBuilder!, to: endpoint.url, method: .post, headers: [.contentType("multipart/form-data")])
    }
}

extension NetworkService {
//    static func post
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
