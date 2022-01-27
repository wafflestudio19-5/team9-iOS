//
//  NotificationPaginationViewModel.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/26.
//

import UIKit

class NotificationPaginationViewModel: PaginationViewModel<Notification> {
    func findDeletionIndex(of notification: Notification) -> Int {
        let dataList = self.dataList.value
        let index = dataList.firstIndex(where: { $0.id == notification.id })
        if let index = index {
            return index
        }
        return -1
    }
}
