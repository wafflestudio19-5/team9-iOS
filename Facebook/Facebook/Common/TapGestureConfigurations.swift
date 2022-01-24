//
//  TapGestureConfigurations.swift.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/11.
//

import Foundation
import RxGesture

struct TapGestureConfigurations {
    
    /// scrollView의 gesture recognizer와 동시 인식되는 것을 방지한다.
    static let scrollViewTapConfig: TapConfiguration = { recognizer, delegate in
        delegate.simultaneousRecognitionPolicy = .never
    }
    
    /// `UIControl`을 터치한 경우 제스쳐 인식을 취소한다.
    static let cancelUIControlConfig: TapConfiguration = { recognizer, delegate in
        delegate.touchReceptionPolicy = .custom { _, shouldReceive in
            return !(shouldReceive.view is UIControl)
        }
    }
}
