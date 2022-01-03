//
//  Rx+Upload.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/31.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

//extension Reactive where Base: Alamofire.Session {
//    func uploadMultipart(multipartFormData: @escaping (MultipartFormData) -> Void,
//                to url: URLConvertible,
//                method: HTTPMethod,
//                headers: HTTPHeaders? = nil) -> Observable<String> {
//        return Observable<String>.create({ observer in
//            AF.upload
//                    AF.upload(multipartFormData: multipartFormData, to: url, method: method, headers: headers,
//                            encodingCompletion: { encodingResult in
//                                switch encodingResult {
//                                case .success(let upload, _, _):
//                                    upload.responseJSON { [weak self] response in
//                                        guard self != nil else { return }
//
//                                        guard response.result.error == nil else {
//                                            observer.onError(response.result.error!)
//                                            return
//                                        }
//                                        if let value: Any = response.result.value {
//                                            observer.onNext(JSON(value)["path"].stringValue)
//                                        }
//                                        observer.onCompleted()
//                                    }
//                                case .failure(let encodingError):
//                                    observer.onError(encodingError)
//                                }
//                    })
//                    return Disposables.create();
//                })
//    }
//}
