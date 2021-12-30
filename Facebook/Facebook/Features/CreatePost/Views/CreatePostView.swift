//
//  CreatePostView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/15.
//

import UIKit
import RxSwift

class CreatePostView: UIView {
    
    
    lazy var keyboardInputAccessory: UIView = {
        let inputAccessory = UIView(frame: .init(x: 0, y: 0, width: 0, height: 50))
        inputAccessory.addSubview(photosButton)
        NSLayoutConstraint.activate([
            photosButton.bottomAnchor.constraint(equalTo: inputAccessory.bottomAnchor, constant: .standardBottomMargin),
            photosButton.leadingAnchor.constraint(equalTo: inputAccessory.leadingAnchor, constant: .standardLeadingMargin),
            photosButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        return inputAccessory
    }()
    
    let imageGridCollectionView = ImageGridCollectionView()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        setStyleForView()
        setLayoutForView()
        bindPlaceholder()
        contentTextView.inputAccessoryView = keyboardInputAccessory
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindPlaceholder() {
        let placeholder = "무슨 생각을 하고 계신가요?"
        contentTextView.text = placeholder
        contentTextView.textColor = .lightGray
        contentTextView.rx.didBeginEditing
            .subscribe { [weak self] _ in
                guard let self = self else {return}
                if self.contentTextView.text == placeholder {
                    self.contentTextView.text = nil
                    self.contentTextView.textColor = .black
                }
            }
            .disposed(by: disposeBag)
        
        contentTextView.rx.didEndEditing
            .subscribe { [weak self] _ in
                guard let self = self else {return}
                if self.contentTextView.text == nil || self.contentTextView.text == "" {
                    self.contentTextView.text = placeholder
                    self.contentTextView.textColor = .lightGray
                }
            }
            .disposed(by: disposeBag)
    }
    
    func enablePostButton() {
        postButton.titleLabel?.textColor = .systemBlue
    }
    
    func disablePostButton () {
        postButton.titleLabel?.textColor = .lightGray
    }
    
    private func setStyleForView() {
        self.backgroundColor = .white
    }
    
    /// `view` > `scrollView` > `stackView`
    /// `stackView`에는 `authorHeader`, `contentTextView`, `imageGridCollectionView`가 포함된다.
    
    private func setLayoutForView() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollViewStack = UIStackView()
        scrollViewStack.translatesAutoresizingMaskIntoConstraints = false
        scrollViewStack.axis = .vertical
        scrollViewStack.addArrangedSubview(contentTextView)
        scrollViewStack.addArrangedSubview(imageGridCollectionView)
        
        self.addSubview(scrollView)
        scrollView.addSubview(scrollViewStack)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            scrollViewStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // MARK: UI Components
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 17)
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 15, right: 10)
        return textView
    }()
    
    let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
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
