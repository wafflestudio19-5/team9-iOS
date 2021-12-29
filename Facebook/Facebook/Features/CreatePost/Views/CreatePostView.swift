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
    
    private func setLayoutForView() {
        self.addSubview(contentTextView)
        self.addSubview(imageGridCollectionView)
        
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
    
            imageGridCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageGridCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageGridCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        
    }
    
    // MARK: UI Components
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17)
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        return button
    }()
    
    lazy var photosButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "photo.on.rectangle.angled")
        config.cornerStyle = .capsule
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()
}
