//
//  SubPostViewModel.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/27.
//

import Foundation
import RxSwift
import RxRelay
import PhotosUI

/// `SubPost`의 생성 및 수정을 관리하는 뷰 모델
class SubPostViewModel {
    let subposts = BehaviorRelay<[SubPost]>(value: [])
    
    func convertPickerToSubposts(results: [String: PHPickerResult]) -> [SubPost] {
        var newSubPosts = [SubPost]()
        for (key, value) in results {
            let index = subposts.value.firstIndex(where: { $0.pickerId == key })
            if let index = index {  // there is existing picker result
                newSubPosts.append(subposts.value[index])
            } else {  // new picker result
                newSubPosts.append(SubPost(pickerId: key, pickerResult: value, imageUrl: nil, content: nil))
            }
        }
        return newSubPosts
    }
    
    func delete() {
        subposts.accept(Array(subposts.value.prefix(3)))
    }
}
