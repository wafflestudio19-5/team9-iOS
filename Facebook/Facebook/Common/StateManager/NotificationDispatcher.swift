//
//  NotificationDispatcher.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/20.
//

import RxSwift
import RxRelay

class NotificationDispatcher: Dispatcher<Notification> {
    
    /// 알림을 확인합니다
    func dispatch(check notification: Notification) {
        let notification = notification
        dispatchedSignals.accept(.init(data: notification, operation: .edit))
    }
    
    /// 알림을 삭제합니다
    func dispatch(delete notification: Notification, at index: Int) {
        if index == -1 { return }
        dispatchedSignals.accept(.init(data: notification, operation: .delete(index: index)))
    }
}
