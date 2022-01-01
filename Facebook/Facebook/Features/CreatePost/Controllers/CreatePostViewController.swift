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
        bindNavigationBarButtonStyle()
        bindPostButton()
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
    
    func bindNavigationBarButtonStyle() {
        // contentTextField가 비어있는 가에 대한 Bool형 event방출
        let hasEnteredContent = createPostView.contentTextView.rx.text.orEmpty.map { (string: String?) -> Bool in
            guard let string = string else {
                return false
            }
            if string == self.createPostView.placeholder {
                return false
            }
            return !string.isEmpty
        }
        
        //contentTextField의 내용 유뮤에 따라 버튼 활성화
        hasEnteredContent.bind(to: self.createPostView.postButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func bindPostButton() {
        createPostView.postButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.pickerViewModel.loadMediaAsDataArray { data in
                    NetworkService.upload(endpoint: .newsfeed(content: self.createPostView.contentTextView.text ?? "", files: data, subcontents: ["하이","하이","하이","하이","하이"]))
                        .subscribe { [weak self] progress in
                            print(progress)
                            progress.element?.responseJSON(completionHandler: {data in
                                print(data)
                            })
                        }
                }
            }.disposed(by: disposeBag)
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
                cell.displayMedia(pickerResult: data)
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

