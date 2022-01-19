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
    
//    override func preprocessBeforeAccept(oldData: [User] = [], results: [User]) -> [User] {
//        guard let query = query else {
//            return []
//        }
//
//        if query.isEmpty {
//            return []
//        }
//        
//        print(query.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted))
//        /// 영문 또는 숫자로만 이루어진 검색어는 아래 로직 적용하지 않음
//        if query.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil {
//            return results
//        }
//
//        if self.dataList.value.count > 0 && results.count == 0 {
//            return self.dataList.value
//        }
//
//        return results
//    }
}
