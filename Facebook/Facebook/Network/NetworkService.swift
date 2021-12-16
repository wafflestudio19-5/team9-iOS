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

struct NetworkService {
    static let session = Session.default
    
    /*
     MARK: Return Type: JSON
     */
    
    static func get(endpoint: Endpoint) -> Observable<Any> {
        return session.rx.json(.get, endpoint.url)
    }
    
    static func post(endpoint: Endpoint) -> Observable<Any> {
        return session.rx.json(.post, endpoint.url)
    }
    
    static func put(endpoint: Endpoint) -> Observable<Any> {
        return session.rx.json(.put, endpoint.url)
    }
    
    static func delete(endpoint: Endpoint) -> Observable<Any> {
        return session.rx.json(.delete, endpoint.url)
    }
    
    /*
     MARK: Return Type: Decodable
     */
    
    static func get<T: Decodable>(endpoint: Endpoint, as: T.Type = T.self) -> Observable<(HTTPURLResponse, T)> {
        return session.rx.responseDecodable(.get, endpoint.url)
    }
}
