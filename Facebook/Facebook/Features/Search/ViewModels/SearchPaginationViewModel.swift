//
//  SearchPaginationViewModel.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/13.
//

import Foundation

class SearchPaginationViewModel: PaginationViewModel<User> {
    
    var query: String?
    
    func setQuery(_ query: String) {
        self.query = query
        self.endpoint = .search(query: query)
    }
    
    func clearData() {
        self.dataList.accept([])
    }
    
    override func preprocessBeforeAccept(oldData: [User] = [], results: [User]) -> [User] {
        guard let query = query else {
            return []
        }
        
        if query.isEmpty {
            return []
        }
        
        if !query.isEmpty && self.dataList.value.count > 0 && results.count == 0 {
            return self.dataList.value
        }
        
        return results
    }
}
