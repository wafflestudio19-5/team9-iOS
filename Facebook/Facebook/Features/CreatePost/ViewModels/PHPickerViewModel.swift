//
//  PHPickerViewModel.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/30.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import PhotosUI


class PHPickerViewModel {
    private var selection = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private weak var presentingViewController: UIViewController?
    
    // 최대 5개까지만 보여준다.
    var firstFiveResults = BehaviorRelay<[PHPickerResult]>(value: [])
    
    let selectionCount = BehaviorRelay<Int>(value: 0)
    
    private lazy var pickerController: PHPickerViewController = {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        // Set the filter type according to the user’s selection.
        configuration.filter = .any(of: [.images, .livePhotos, .videos])
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
