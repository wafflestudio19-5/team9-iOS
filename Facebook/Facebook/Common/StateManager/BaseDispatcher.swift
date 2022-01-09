//
//  GenericDispatcher.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/09.
//

import Foundation
import RxSwift
import RxRelay


class Dispatcher<DataModel: Identifiable> {
    let asObservable = PublishRelay<DataModel>()
    
    func bind(with dataSource: BehaviorRelay<[DataModel]>) -> Disposable {
        return asObservable.bind { data in
            var dataList = dataSource.value
            let index = dataList.firstIndex(where: { $0.id == data.id })
            if let index = index {
                dataList[index] = data
                dataSource.accept(dataList)
            }
        }
    }
    
    func dispatch(_ data: DataModel) {
        asObservable.accept(data)
    }
}
