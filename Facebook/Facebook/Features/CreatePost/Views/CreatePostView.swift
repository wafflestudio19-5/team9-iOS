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
    var scrollViewBottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyleForView()
        setLayoutForView()
        contentTextView.inputAccessoryView = keyboardAccessory
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView() {
        self.backgroundColor = .systemBackground
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
        scrollViewStack.addArrangedSubview(contentTextView)
        scrollViewStack.addArrangedSubview(imageGridCollectionView)
        
        self.addSubview(scrollView)
        scrollView.addSubview(scrollViewStack)
        
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        scrollViewBottomConstraint?.priority = .defaultHigh
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollViewBottomConstraint!,
        ])
        NSLayoutConstraint.activateFourWayConstraints(subview: scrollViewStack, containerView: scrollView)
        NSLayoutConstraint.activate([
            scrollViewStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // MARK: UI Components
    
    lazy var keyboardAccessory: UIView = {
        let divider = Divider()
        let customInputView = CustomInputAccessoryView()
        customInputView.addSubview(photosButton)
        customInputView.addSubview(divider)
        NSLayoutConstraint.activate([
            photosButton.topAnchor.constraint(equalTo: customInputView.topAnchor, constant: 8),
            photosButton.bottomAnchor.constraint(equalTo: customInputView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            photosButton.leadingAnchor.constraint(equalTo: customInputView.leadingAnchor, constant: .standardLeadingMargin),
            photosButton.widthAnchor.constraint(equalToConstant: 50),
            photosButton.heightAnchor.constraint(equalToConstant: 35),
            
            divider.leadingAnchor.constraint(equalTo: customInputView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: customInputView.trailingAnchor),
            divider.topAnchor.constraint(equalTo: customInputView.topAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
            
        ])
        return customInputView
    }()
    
    lazy var contentTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.isScrollEnabled = false
        textView.placeholder = self.placeholder
        textView.font = .systemFont(ofSize: 17)
        textView.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
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
