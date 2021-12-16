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
    
    let loadMoreToggle = PublishSubject<Void>()
    let dataList = BehaviorRelay<[DataModel]>(value: [])
    
    init(endpoint: Endpoint) {
        self.endpoint = endpoint
        bind()
        loadMore()
    }
    
    func loadMore() {
        loadMoreToggle.onNext(())
    }
    
    private func bind() {
        loadMoreToggle
            .subscribe { [weak self] _ in
                if let hasNext = self?.hasNext, hasNext {
                    self?.publishToDataList()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func publishToDataList() {
        let endpoint = endpoint.withPage(page: currentPage)
        NetworkService
            .get(endpoint: endpoint, as: PaginatedResponse<DataModel>.self)
            .observe(on: MainScheduler.instance)
            .subscribe { event in
                
                if event.isCompleted {
                    return
                }
                
                guard let paginatedResponse = event.element?.1 else {
                    print("데이터 로드 중 오류 발생: \(endpoint.url)")
                    return
                }
                
                self.dataList.accept(self.dataList.value + paginatedResponse.results)
                self.currentPage += 1
                self.hasNext = (paginatedResponse.next != nil)
            }
            .disposed(by: disposeBag)
    }
}
