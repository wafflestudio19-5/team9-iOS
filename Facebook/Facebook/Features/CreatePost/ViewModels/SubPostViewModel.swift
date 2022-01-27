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
    var data: Data?
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
            if subpostsList[index].prefetchedImage != nil || subpost.pickerResult == nil {
                continue
            }
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
    
    func storeContents(row: Int, content: String) {
        var subpostList = subposts.value
        subpostList[row].content = content
        subposts.accept(subpostList)
    }
    
    func acceptNewSubposts(subposts: [SubPost]) {
        var previousSubPosts = self.subposts.value
        for subpost in subposts {
            guard let _ = previousSubPosts.firstIndex(where: { prev in prev.pickerId == subpost.pickerId }) else {
                previousSubPosts.append(subpost)
                continue
            }
        }
        self.subposts.accept(previousSubPosts)
    }
    
    // TODO: Duplicate
    func loadSubPostData(to pointSize: CGSize? = nil, scale: CGFloat = UIScreen.main.scale, completion: (([SubPost]) -> Void)? = nil) {
        let group = DispatchGroup()
        var selectedDataArray: [SubPost] = []
        for subpost in self.subposts.value {
            
            // 이미지 데이터가 URL 형식으로 있는 경우
            guard let result = subpost.pickerResult else {
                selectedDataArray.append(subpost)
                continue
            }
            
            group.enter()  // 루프 시작
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { (url, error) in
                guard let url = url else { return }
                let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
                guard let source = CGImageSourceCreateWithURL(url as CFURL, sourceOptions) else { return }
                
                var maxDimensionInPixels: CGFloat {
                    guard let pointSize = pointSize else {
                        return 3000
                    }
                    return max(pointSize.width, pointSize.height) * scale
                }
                
                let downsampleOptions = [
                    kCGImageSourceCreateThumbnailFromImageAlways: true,
                    kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels,
                ] as CFDictionary
                
                guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else { return }
                
                let data = NSMutableData()  // data to return
                
                // 전송할 파일 형식은 jpeg
                guard let imageDestination = CGImageDestinationCreateWithData(data, UTType.jpeg.identifier as CFString, 1, nil) else { return }
                
                // PNG 파일은 압축하지 않는다.
                let isPNG: Bool = {
                    guard let utType = cgImage.utType else { return false }
                    return (utType as String) == UTType.png.identifier
                }()
                
                let destinationProperties = [
                    kCGImageDestinationLossyCompressionQuality: isPNG ? 1.0 : 0.75
                ] as CFDictionary
                
                CGImageDestinationAddImage(imageDestination, cgImage, destinationProperties)
                CGImageDestinationFinalize(imageDestination)
                
                var subpostWithData = subpost
                subpostWithData.data = data as Data
                selectedDataArray.append(subpostWithData)
                group.leave() // async 작업 종료
            }
        }
        
        group.notify(queue: .main) {  // 모든 작업이 완료되면 실행
            if let completion = completion {
                completion(selectedDataArray)
            }
        }
    }
}
