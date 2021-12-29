//
//  CreatePostViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/15.
//

import UIKit
import RxSwift
import RxGesture
import PhotosUI

class CreatePostViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    private let dummyObservables = Observable.just([1,2,3,4,5])
    
    override func loadView() {
        view = CreatePostView()
    }
    
    var createPostView: CreatePostView {
        guard let view = view as? CreatePostView else { fatalError("CreatePostView is not loaded.") }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "게시물 만들기"
        self.createPostView.contentTextView.becomeFirstResponder()
        setNavigationBarStyle()
        setNavigationBarItems()
        bindNavigationBarItems()
        bindPhotosButton()
        bindImageGridView()
    }
    
    func setNavigationBarStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .lightGray.withAlphaComponent(0.1)
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    func setNavigationBarItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(popToPrevious)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createPostView.postButton)
    }
    
    @objc private func popToPrevious() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    func bindNavigationBarItems() {
        createPostView.postButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                NetworkService.post(endpoint: .newsfeed(content: self.createPostView.contentTextView.text ?? ""), as: Post.self)
                    .subscribe { [weak self] _ in
                        guard let self = self else { return }
                        guard let rootTabBarController = self.presentingViewController as? RootTabBarController,
                              let newsfeedVC = rootTabBarController.newsfeedNavController.viewControllers.first as? NewsfeedTabViewController
                        else { return }
                        newsfeedVC.viewModel.refresh()
                        self.dismiss(animated: true, completion: nil)
                    }
                    .disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
        
        //contentTextField가 비어있는 가에 대한 Bool형 event방출
        let hasEnteredContent = createPostView.contentTextView.rx.text.orEmpty.map { !$0.isEmpty }
        
        //contentTextField의 내용 유뮤에 따라 버튼 활성화
        hasEnteredContent.bind(to: self.createPostView.postButton.rx.isEnabled).disposed(by: disposeBag)
        
        //contentTextField의 내용 유뮤에 따라 버튼 색상 변화
        hasEnteredContent
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                if result {
                    self.createPostView.enablePostButton()
                } else {
                    self.createPostView.disablePostButton()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Photo Picker
    // 아래부터는 사진 첨부 버튼을 눌렀을 때 관련한 로직입니다.
    
    private var selection = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    
    private func bindPhotosButton() {
        createPostView.photosButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.presentPicker()
            }
            .disposed(by: disposeBag)
    }
    
    private func presentPicker() {
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
        present(picker, animated: true)
    }
}

extension CreatePostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let existingSelection = self.selection
        var newSelection = [String: PHPickerResult]()
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = existingSelection[identifier] ?? result
        }
        
        // Track the selection in case the user deselects it later.
        selection = newSelection
        selectedAssetIdentifiers = results.map(\.assetIdentifier!)
        
        dismiss(animated: true)
//        selectedAssetIdentifierIterator = selectedAssetIdentifiers.makeIterator()
//
//        if selection.isEmpty {
//            displayEmptyImage()
//        } else {
//            displayNext()
//        }
    }
}


// MARK: Image Grid

extension CreatePostViewController: UICollectionViewDelegateFlowLayout {
    func bindImageGridView() {
        dummyObservables
            .bind(to: createPostView.imageGridCollectionView.rx.items(cellIdentifier: ImageGridCell.reuseIdentifier, cellType: ImageGridCell.self)) { row, data, cell in
                cell.backgroundColor = .red
            }
            .disposed(by: disposeBag)
        createPostView.imageGridCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = indexPath.item
        let width = collectionView.bounds.size.width
        let padding:CGFloat = 5
        if item < 2 {
            let itemWidth:CGFloat = (width - padding) / 2.0
            return CGSize(width: itemWidth, height: itemWidth)
        } else {
            let itemWidth:CGFloat = (width - 2 * padding) / 3.0
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
}
