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
import RxCocoa
import RxKeyboard

class CreatePostViewController: UIViewController {
    let disposeBag = DisposeBag()
    private let pickerViewModel = PHPickerViewModel()
    
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
        bindNavigationBarButtonStyle()
        bindPostButton()
        bindPhotosButton()
        bindImageGridView()
        bindKeyboardHeight()
    }
    
    func setNavigationBarStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    func setNavigationBarItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(popToPrevious)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createPostView.postButton)
    }
    
    @objc private func popToPrevious() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func bindKeyboardHeight() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                UIView.animate(withDuration: 0) {
                    self.createPostView.scrollViewBottomConstraint?.constant = -1 * (keyboardVisibleHeight)
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindNavigationBarButtonStyle() {
        // contentTextField의 내용 유무에 따라 버튼 활성화
        createPostView.contentTextView.isEmptyObservable
            .map { !$0 }
            .bind(to:self.createPostView.postButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func bindPostButton() {
        var callbackDisposeBag = DisposeBag()
        createPostView.postButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                // get the VC that presented this VC
                guard let rootTabBarController = self.presentingViewController as? RootTabBarController,
                      let newsfeedVC = rootTabBarController.newsfeedNavController.viewControllers.first as? NewsfeedTabViewController
                else { return }
                
                // dismiss current VC first
                self.dismiss(animated: true, completion: nil)

                // show progress bar with initial value (1%)
                let tempProgress = Progress()
                tempProgress.totalUnitCount = 100
                tempProgress.completedUnitCount = 1
                DispatchQueue.main.async {
                    newsfeedVC.headerViews.uploadProgressHeaderView.isHidden = false
                    newsfeedVC.headerViews.uploadProgressHeaderView.displayProgress(progress: tempProgress)
                }
                
                // load selected images as an array of data
                self.pickerViewModel.loadMediaAsDataArray { array in
                    NetworkService.upload(endpoint: .newsfeed(content: self.createPostView.contentTextView.text ?? "", files: array, subcontents: [String](repeating: "1", count: self.pickerViewModel.selectionCount.value)))
                        .subscribe { event in
                            let request = event.element
                            let progress = request?.uploadProgress
                            DispatchQueue.main.async {
                                newsfeedVC.headerViews.uploadProgressHeaderView.displayProgress(progress: progress)
                            }

                            request?.responseDecodable(of: Post.self) { dataResponse in
                                guard let post = dataResponse.value else { return }
                                StateManager.of.post.dispatch(.init(data: post, operation: .insert(index: 0)))
                                newsfeedVC.headerViews.uploadProgressHeaderView.isHidden = true
                                callbackDisposeBag = DisposeBag()
                            }
                        }
                        .disposed(by: callbackDisposeBag)
                }
            }.disposed(by: disposeBag)
    }
    
    
    // MARK: Photo Picker
    
    private func bindPhotosButton() {
        createPostView.photosButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.pickerViewModel.presentPickerVC(presentingVC: self)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Image Grid Binding with PickerViewModel

extension CreatePostViewController {
    func bindImageGridView() {
        pickerViewModel.firstFiveResults
            .bind(to: createPostView.imageGridCollectionView.rx.items(cellIdentifier: ImageGridCell.reuseIdentifier, cellType: ImageGridCell.self)) { row, data, cell in
                cell.displayMedia(from: data)
            }
            .disposed(by: disposeBag)
        
        pickerViewModel.selectionCount
            .bind { [weak self] count in
                guard let self = self else { return }
                self.createPostView.imageGridCollectionView.numberOfImages = count
            }
            .disposed(by: disposeBag)
    }
}

