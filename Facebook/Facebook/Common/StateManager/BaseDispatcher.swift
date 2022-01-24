//
//  GenericDispatcher.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/09.
//

import Foundation
import RxSwift
import RxRelay


enum Operation {
    case insert(index: Int)
    case delete(index: Int)
    case deleteRows(indices: [Int])
    case edit
}


struct Signal<DataModel> {
    var data: DataModel
    var operation: Operation
}


class Dispatcher<DataModel: Identifiable> {
    let dispatchedSignals = PublishRelay<Signal<DataModel>>()
    
    func dispatch(_ signal: Signal<DataModel>) {
        dispatchedSignals.accept(signal)
    }
    
    // MARK: For Simple Data
    
    /// Bind the dispatched signals with `DataModel` relay.
    func bind(with dataSource: BehaviorRelay<DataModel>) -> Disposable {
        return dispatchedSignals.bind { [weak self] signal in
            guard let self = self else { return }
            switch signal.operation {
            case .edit:
                self._edit(dataSource: dataSource, signal: signal)
            default:
                print("Only EDIT operation is supported for single-value dataSource.")
            }
        }
    }
    
    func _edit(dataSource: BehaviorRelay<DataModel>, signal: Signal<DataModel>) {
        dataSource.accept(signal.data)
    }
    
    // MARK: For List Data
    
    /// Bind the dispatched signals with the list of `DataModel`
    func bind(with dataSource: BehaviorRelay<[DataModel]>) -> Disposable {
        return dispatchedSignals.bind { [weak self] signal in
            guard let self = self else { return }
            switch signal.operation {
            case .insert:
                self._insert(dataSource: dataSource, signal: signal)
            case .delete:
                self._delete(dataSource: dataSource, signal: signal)
            case .edit:
                self._edit(dataSource: dataSource, signal: signal)
            case .deleteRows:
                self._deleteRows(dataSource: dataSource, signal: signal)
            }
        }
    }
    
    func _insert(dataSource: BehaviorRelay<[DataModel]>, signal: Signal<DataModel>) {
        guard case .insert(let index) = signal.operation else { return }
        var dataList = dataSource.value
        dataList.insert(signal.data, at: index)
        dataSource.accept(dataList)
    }
    
    func _delete(dataSource: BehaviorRelay<[DataModel]>, signal: Signal<DataModel>) {
        guard case .delete(let index) = signal.operation else { return }
        var dataList = dataSource.value
        dataList.remove(at: index)
        dataSource.accept(dataList)
    }
    
    func _deleteRows(dataSource: BehaviorRelay<[DataModel]>, signal: Signal<DataModel>) {
        guard case .deleteRows(let indices) = signal.operation else { return }
        let dataList = dataSource.value
        let removedDataList = dataList
            .enumerated()
            .filter { !indices.contains($0.offset) }
            .map { $0.element }
        dataSource.accept(removedDataList)
    }
    
    func _edit(dataSource: BehaviorRelay<[DataModel]>, signal: Signal<DataModel>) {
        var dataList = dataSource.value
        let index = dataList.firstIndex(where: { $0.id == signal.data.id })
        if let index = index {
            dataList[index] = signal.data
            dataSource.accept(dataList)
        }
    }
}
