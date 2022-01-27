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
    private let subPostViewModel = SubPostViewModel()
    private var postToShare: Post?
    private var updateListAfterCreation = true
    
    convenience init(sharing post: Post?, update: Bool = true) {
        self.init(nibName: nil, bundle: nil)
        self.postToShare = post?.postToShare
        self.updateListAfterCreation = update
    }
    
    override func loadView() {
        view = CreatePostView(sharing: postToShare)
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
    
    func presentEditSubPostVC() {
        let vc = SubPostCaptionViewController(viewModel: subPostViewModel)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        return self.present(nvc, animated: true, completion: nil)
    }
    
    // MARK: Binding
    
    private func bindKeyboardHeight() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                UIView.animate(withDuration: 0) {
                    self.createPostView.scrollView.contentInset.bottom = keyboardVisibleHeight == 0 ? 0 : keyboardVisibleHeight - self.view.safeAreaInsets.bottom
                    self.createPostView.scrollView.verticalScrollIndicatorInsets.bottom = self.createPostView.scrollView.contentInset.bottom
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindNavigationBarButtonStyle() {
        // contentTextField의 내용 유무에 따라 버튼 활성화
        let empty = createPostView.contentTextView.isEmptyObservable
        let photoCount = pickerViewModel.selectionCount
        Observable.combineLatest(empty, photoCount) { [weak self] isEmpty, selectedCount in
            return !isEmpty || selectedCount > 0 || self?.postToShare != nil
        }
        .bind(to: self.createPostView.postButton.rx.isEnabled)
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
                newsfeedVC.tableView.scrollToRow(at: .init(row: 0, section: 0), at: .none, animated: true)
                
                // show progress bar with initial value (1%)
                let tempProgress = Progress()
                tempProgress.totalUnitCount = 100
                tempProgress.completedUnitCount = 1
                DispatchQueue.main.async {
                    newsfeedVC.headerViews.uploadProgressHeaderView.isHidden = false
                    newsfeedVC.headerViews.uploadProgressHeaderView.displayProgress(progress: tempProgress)
                }
                
                // load selected images as an array of data
                self.subPostViewModel.loadSubPostData { subposts in
                    NetworkService.upload(endpoint: .newsfeed(content: self.createPostView.contentTextView.text ?? "",
                                                              files: subposts.map{$0.data}.compactMap{$0},
                                                              subcontents: subposts.map{$0.content}.compactMap{$0},
                                                              scope: self.createPostView.createHeaderView.selectedScope,
                                                              sharing: self.postToShare?.id
                                                             ))
                        .subscribe { event in
                            let request = event.element
                            let progress = request?.uploadProgress
                            DispatchQueue.main.async {
                                newsfeedVC.headerViews.uploadProgressHeaderView.displayProgress(progress: progress)
                            }
                            
                            request?.responseDecodable(of: Post.self) { dataResponse in
                                guard let post = dataResponse.value else { return }
                                if self.updateListAfterCreation {
                                    StateManager.of.post.dispatch(.init(data: post, operation: .insert(index: 0)))
                                }
                                newsfeedVC.headerViews.uploadProgressHeaderView.isHidden = true
                                callbackDisposeBag = DisposeBag()
                            }
                        }
                        .disposed(by: callbackDisposeBag)
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindPhotosButton() {
        createPostView.photosButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.pickerViewModel.presentPickerVC(presentingVC: self)
            }
            .disposed(by: disposeBag)
    }
    
    
    func bindImageGridView() {
        pickerViewModel.pickerResults
            .map { [weak self] in self?.subPostViewModel.convertPickerToSubposts(results: $0) }
            .compactMap { $0 }
            .bind(to: subPostViewModel.subposts)
            .disposed(by: disposeBag)
        
        subPostViewModel.subposts
            .map { $0.prefix(5) }
            .bind(to: createPostView.imageGridCollectionView.rx.items(cellIdentifier: ImageGridCell.reuseIdentifier, cellType: ImageGridCell.self)) { row, data, cell in
                if let pickerData = data.pickerResult {
                    cell.displayMedia(from: pickerData)
                } else if let urlString = data.imageUrl {
                    cell.displayMedia(from: URL(string: urlString))
                }
            }
            .disposed(by: disposeBag)
        
        subPostViewModel.subposts
            .map { $0.count }
            .bind { [weak self] count in
                guard let self = self else { return }
                self.createPostView.imageGridCollectionView.numberOfImages = count
            }
            .disposed(by: disposeBag)
        
        createPostView.imageGridCollectionView.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
            .when(.recognized)
            .bind { [weak self] _ in
                self?.presentEditSubPostVC()
            }
            .disposed(by: disposeBag)
    }
}
