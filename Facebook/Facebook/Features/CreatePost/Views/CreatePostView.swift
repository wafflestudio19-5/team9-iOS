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
        scrollView.keyboardDismissMode = .interactive
        
        let scrollViewStack = UIStackView()
        scrollViewStack.axis = .vertical
        scrollViewStack.addArrangedSubview(createHeaderView)
        scrollViewStack.addArrangedSubview(contentTextView)
        scrollViewStack.addArrangedSubview(imageGridCollectionView)
        
        self.addSubview(scrollView)
        scrollView.addSubview(scrollViewStack)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(0)
            make.bottom.equalTo(0).priority(.high)
        }
        
        scrollViewStack.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }
    
    // MARK: UI Components
    
    let scrollView = ResponsiveScrollView()
    
    lazy var keyboardAccessory: UIView = {
        let divider = Divider()
        let customInputView = CustomInputAccessoryView()
        customInputView.addSubview(photosButton)
        customInputView.addSubview(divider)
        
        photosButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(35)
            make.top.bottom.equalTo(customInputView.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(customInputView).inset(CGFloat.standardLeadingMargin)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(customInputView)
            make.height.equalTo(1)
        }

        return customInputView
    }()
    
    var createHeaderView = CreateHeaderView()
    
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
        button.configuration = config
        return button
    }()
}
