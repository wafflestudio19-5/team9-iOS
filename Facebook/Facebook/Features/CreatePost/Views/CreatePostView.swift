//
//  CreatePostView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/15.
//

import UIKit
import RxSwift

class CreatePostView: UIView {
    lazy var profileImage: UIImageView = {
        let image = UIImage(systemName: "person.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "writer"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyleForView()
        setLayoutForView()
        bindPlaceholder()
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
        self.addSubview(profileImage)
        self.addSubview(nameLabel)
        self.addSubview(contentTextView)
        
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            profileImage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
            contentTextView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            contentTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            contentTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            contentTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}
 
