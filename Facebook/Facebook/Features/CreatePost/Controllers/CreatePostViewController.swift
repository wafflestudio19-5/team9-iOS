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

class CreatePostViewController: UIViewController {
    let disposeBag = DisposeBag()
    
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
    
    private let pickerViewModel = PHPickerViewModel()
    
    private func bindPhotosButton() {
        createPostView.photosButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.pickerViewModel.presentPickerVC(presentingVC: self)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Image Grid

extension CreatePostViewController {
    func bindImageGridView() {
        pickerViewModel.firstFiveResults
            .bind(to: createPostView.imageGridCollectionView.rx.items(cellIdentifier: ImageGridCell.reuseIdentifier, cellType: ImageGridCell.self)) { row, data, cell in
                cell.backgroundColor = .red
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

