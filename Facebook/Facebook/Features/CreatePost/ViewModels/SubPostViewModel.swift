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
import Kingfisher


struct SubPost {
    var id: Int?
    var pickerId: String?
    var pickerResult: PHPickerResult?
    var imageUrl: String?
    var prefetchedImage: UIImage?
    var content: String?
}

/// `SubPost`의 생성 및 수정을 관리하는 뷰 모델
class SubPostViewModel {
    let subposts = BehaviorRelay<[SubPost]>(value: [])
    let prefetchedSubposts = BehaviorRelay<[SubPost]>(value: [])
    var isPrefetching = BehaviorRelay<Bool>(value: true)
    
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
    
    func prefetchImages() {
        let group = DispatchGroup()
        
        // Prefetch URL Type Subpost
        group.enter()
        let urls = subposts.value.map { $0.imageUrl }.compactMap { URL(string: $0 ?? "") }
        let prefetcher = ImagePrefetcher(urls: urls, options: [.processor(KFProcessors.shared.downsampling), .diskCacheExpiration(.never)]) { skippedResources, failedResources, completedResources in
            group.leave()
        }
        prefetcher.start()
        
        // Prefetch PHPickerResult
        var subpostsList = self.subposts.value
        for (index, subpost) in subposts.value.enumerated() {
            group.enter()
            subpost.pickerResult?.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let image = image as? UIImage else { return }
                subpostsList[index].prefetchedImage = image
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.subposts.accept(subpostsList)
            self.prefetchedSubposts.accept(subpostsList)
            self.isPrefetching.accept(false)
        }
    }
}
