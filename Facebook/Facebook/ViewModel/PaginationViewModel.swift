//
//  PaginationViewModel.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/16.
//

import Foundation
import RxSwift
import RxRelay
import RxAlamofire

class PaginationViewModel<DataModel: Codable> {
    /// 앱 내에서 Infinite Scrolling이 필요한 경우가 많을 것으로 예상되어, 해당 로직을 재사용할 수 있도록 `ViewModel`로 작성했습니다..
    
    private let disposeBag = DisposeBag()
    private var endpoint: Endpoint
    
    private var currentPage: Int = 1
    private var hasNext: Bool = true
    
    private let loadMoreToggle = PublishSubject<Void>()
    private let refreshToggle = PublishSubject<Void>()
    
    let dataList = BehaviorRelay<[DataModel]>(value: [])
    
    /// 로딩 인디케이터와 새로고침 인디케이터는 독립적으로 작동하므로 별도의 변수로 두었습니다.
    /// `refreshComplete`은 새로고침 인디케이터의 작동을 멈추기 위해 사용됩니다.
    let isLoading = BehaviorRelay<Bool>(value: false)
    let isRefreshing = BehaviorRelay<Bool>(value: false)
    let refreshComplete = BehaviorRelay<Bool>(value: false)
    
    private var isFetchingData: Bool {
        return isLoading.value || isRefreshing.value
    }
    
    init(endpoint: Endpoint) {
        self.endpoint = endpoint
        bind()
        loadMore()
    }
    
    func loadMore() {
        if isFetchingData || !hasNext { return }
        loadMoreToggle.onNext(())
    }
    
    func refresh() {
        if isFetchingData { return }
        NetworkService.cancelAllRequests()
        refreshToggle.onNext(())
    }
    
    private func bind() {
        loadMoreToggle
            .subscribe { [weak self] _ in
                if let hasNext = self?.hasNext, hasNext {
                    self?.isLoading.accept(true)
                    self?.publishToDataList()
                }
            }
            .disposed(by: disposeBag)
        
        refreshToggle
            .subscribe { [weak self] _ in
                self?.currentPage = 1
                self?.isRefreshing.accept(true)
                self?.publishToDataList(isRefreshing: true)
            }
            .disposed(by: disposeBag)
    }
        
    private func publishToDataList(isRefreshing: Bool = false) {
        let endpoint = endpoint.withPage(page: currentPage)
        NetworkService
            .get(endpoint: endpoint, as: PaginatedResponse<DataModel>.self)
            .subscribe { [weak self] event in
                guard let self = self else { return }
                
                if event.isCompleted {
                    return
                }
                
                guard let paginatedResponse = event.element?.1 else {
                    print("데이터 로드 중 오류 발생: \(endpoint.url)")
                    return
                }
                
                self.currentPage += 1
                self.hasNext = (paginatedResponse.next != nil)
                
                if isRefreshing {
                    self.dataList.accept(paginatedResponse.results)
                    self.isRefreshing.accept(false)
                    self.refreshComplete.accept(true)
                } else {
                    self.dataList.accept(self.dataList.value + paginatedResponse.results)
                    self.isLoading.accept(false)
                }
            }
            .disposed(by: disposeBag)
    }
}