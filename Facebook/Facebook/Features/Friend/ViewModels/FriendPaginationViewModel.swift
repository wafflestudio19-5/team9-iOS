//
//  FriendPaginationViewModel.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/19.
//

import Foundation

class FriendPaginationViewModel: PaginationViewModel<User> {
    
    private var count: Int {
        guard let lastResponse = lastResponse else { return 0 }
        guard let count = lastResponse.count else { return 0 }
        return count
    }
    
    func searchFriend(key: String) {
        var endpoint = Endpoint.friend(id: 0, limit: count)
        endpoint.path = self.endpoint.path
        NetworkService
            .get(endpoint: endpoint, as: PaginatedResponse<User>.self)
            .subscribe(onNext: { [weak self] element in
                guard let self = self else { return }
                let paginatedResponse = element.1
                self.lastResponse = paginatedResponse
                let results = paginatedResponse.results
                let filteredResults = results.filter { $0.username.contains(key.trimmingCharacters(in: .whitespaces)) }
                print(filteredResults)
                self.dataList.accept(self.preprocessBeforeAccept(results: filteredResults))
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
