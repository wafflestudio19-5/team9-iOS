//
//  KFProcessors.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/12.
//

import Foundation
import Kingfisher

/// 이미지 캐싱을 효율적으로 하기 위해 공통된 프로세서를 사용한다.
struct KFProcessors {
    static let shared = KFProcessors()
    
    // Downsampling
    let downsampling = DownsamplingImageProcessor(size: CGSize(width: 500, height: 500))

}
