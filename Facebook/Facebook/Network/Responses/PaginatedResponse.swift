//
//  PaginatedDataResponse.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/16.
//

import Foundation


struct PaginatedResponse<DataModel: Codable>: Codable {
    let count: String?
    let next: String?
    let previous: String?
    let results: [DataModel]
}
