//
//  FriendPaginationViewModel.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/19.
//

import Foundation

class FriendPaginationViewModel: PaginationViewModel<User> {
    
    lazy var allFriendList: [User] = []
    
    private var count: Int {
        guard let lastResponse = lastResponse else { return 0 }
        guard let count = lastResponse.count else { return 0 }
        return count
    }
    
    func reload(friend: User) {
        var friendList = dataList.value
        guard let index = friendList.firstIndex(where: { $0.id == friend.id }) else { return }
        friendList[index] = friend
        self.dataList.accept(friendList)
    }
    
    func searchFriend(key: String) {
        if allFriendList.count == 0 {
            var endpoint = Endpoint.friend(id: 0, limit: count)
            endpoint.path = self.endpoint.path
            NetworkService
                .get(endpoint: endpoint, as: PaginatedResponse<User>.self)
                .subscribe(onNext: { [weak self] element in
                    guard let self = self else { return }
                    let paginatedResponse = element.1
                    self.lastResponse = paginatedResponse
                    self.allFriendList = paginatedResponse.results
                }, onError: { error in
                    print(error)
                }, onCompleted: { [weak self] in
                    self?.filterList(key: key)
                })
                .disposed(by: disposeBag)
        } else {
            filterList(key: key)
        }
        
    }
    
    private func filterList(key: String) {
        let filteredResults = allFriendList.filter { $0.username.contains(key.trimmingCharacters(in: .whitespaces)) }
        self.dataList.accept(filteredResults)
    }
}
