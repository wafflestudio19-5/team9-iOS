//
//  CreatePostView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/15.
//

import UIKit
import RxSwift
import RxKeyboard

class CreatePostView: UIView {
    let placeholder = "무슨 생각을 하고 계신가요?"
    let imageGridCollectionView = ImageGridCollectionView()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyleForView()
        setLayoutForView()
        contentTextView.inputAccessoryView = keyboardInputAccessory
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView() {
        self.backgroundColor = .white
    }
    
    /// `view` > `scrollView` > `stackView`
    /// `stackView`에는 `authorHeader`, `contentTextView`, `imageGridCollectionView`가 포함된다.
    
    private func setLayoutForView() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        
        let scrollViewStack = UIStackView()
        scrollViewStack.translatesAutoresizingMaskIntoConstraints = false
        scrollViewStack.axis = .vertical
//        scrollViewStack.layoutMargins = .init(top: 20, left: 0, bottom: 0, right: 20)
//        scrollViewStack.isLayoutMarginsRelativeArrangement = true
        scrollViewStack.addArrangedSubview(contentTextView)
        scrollViewStack.addArrangedSubview(imageGridCollectionView)
        
        self.addSubview(scrollView)
        scrollView.addSubview(scrollViewStack)
        
        let scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        scrollViewBottomConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollViewBottomConstraint,
        ])
        NSLayoutConstraint.activateFourWayConstraints(subview: scrollViewStack, containerView: scrollView)
        NSLayoutConstraint.activate([
            scrollViewStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Keyboard의 높이에 따라 스크롤뷰 bottomConstraint 조정
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                let bottomConstraint = scrollViewBottomConstraint

                if keyboardVisibleHeight == 0 {
                    bottomConstraint.constant = -16.0
                } else {
                    let height = keyboardVisibleHeight - self.safeAreaInsets.bottom
                    bottomConstraint.constant = -height - 16.0
                }
                self.layoutIfNeeded()
            }).disposed(by: disposeBag)
    }
    
    // MARK: UI Components
    
    lazy var keyboardInputAccessory: UIView = {
        let inputAccessory = UIView(frame: .init(x: 0, y: 0, width: 0, height: 50))
        inputAccessory.autoresizingMask = .flexibleHeight
        inputAccessory.addSubview(photosButton)
        NSLayoutConstraint.activate([
//            photosButton.bottomAnchor.constraint(equalTo: inputAccessory.bottomAnchor, constant: .standardBottomMargin),
            photosButton.topAnchor.constraint(equalTo: inputAccessory.topAnchor, constant: 10),
            photosButton.leadingAnchor.constraint(equalTo: inputAccessory.leadingAnchor, constant: .standardLeadingMargin),
            photosButton.widthAnchor.constraint(equalToConstant: 50),
            photosButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        return inputAccessory
    }()
    
    lazy var contentTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.isScrollEnabled = false
        textView.placeholder = self.placeholder
        textView.font = .systemFont(ofSize: 17)
        textView.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        textView.backgroundColor = .systemGroupedBackground
//        textView.textContainerInset = .init(top: 10, left: 10, bottom: 15, right: 10)
        return textView
    }()
    
    let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    let photosButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "photo.on.rectangle.angled")
        config.cornerStyle = .capsule
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()
}
