//
//  PHPickerViewModel.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/30.
//

import RxSwift
import RxCocoa
import UIKit
import PhotosUI
import MobileCoreServices

class PHPickerViewModel {
    private var selection = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private weak var presentingViewController: UIViewController?
    private let dispatchQueue = DispatchQueue(label: "PHPickerViewModel.dispatchQueue")
    
    // 최대 5개까지만 보여준다.
    var firstFiveResults = BehaviorRelay<[PHPickerResult]>(value: [])
    
    let selectionCount = BehaviorRelay<Int>(value: 0)
    
    private lazy var pickerController: PHPickerViewController = {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        // Set the filter type according to the user’s selection.
        configuration.filter = .any(of: [.images])
        // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.preferredAssetRepresentationMode = .current
        // Set the selection behavior to respect the user’s selection order.
        configuration.selection = .ordered
        // Set the selection limit to enable multiselection.
        configuration.selectionLimit = 80
        // Set the preselected asset identifiers with the identifiers that the app tracks.
        configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }()
    
    func presentPickerVC(presentingVC: UIViewController) {
        presentingViewController = presentingVC
        presentingVC.present(pickerController, animated: true)
    }
    
    func dismissPickerVC() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension PHPickerViewModel: PHPickerViewControllerDelegate {
    // 사진 선택이 완료되었을 때 사용되는 delegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let existingSelection = self.selection
        var newSelection = [String: PHPickerResult]()
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = existingSelection[identifier] ?? result
        }
        
        // Track the selection in case the user deselects it later.
        selection = newSelection
        selectionCount.accept(newSelection.count)
        firstFiveResults.accept(Array(newSelection.map{ $0.1 }.prefix(5)))
        selectedAssetIdentifiers = results.map(\.assetIdentifier!)
        
        dismissPickerVC()
    }
}

extension PHPickerViewModel {
    
    /**
     선택된 이미지를 `Data`의 배열로 반환한다.
     
     - parameter to: 이미지를 다운샘플링하기 위한 타겟 해상도
     - parameter completion: 모든 이미지의 (비동기) 로딩이 완료되면 실행되는 함수
     */
    func loadMediaAsDataArray(to pointSize: CGSize? = nil, scale: CGFloat = UIScreen.main.scale, completion: (([Data]) -> Void)? = nil) {
        let group = DispatchGroup()
        var selectedDataArray: [Data] = []
        for identifier in self.selectedAssetIdentifiers {
            group.enter()  // 루프 시작
            let result = selection[identifier]!
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
                
                selectedDataArray.append(data as Data)
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
