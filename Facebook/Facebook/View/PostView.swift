//
//  PostView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/05.
//

import UIKit
import KakaoSDKCommon

class PostView: UIView {

    let postTableView = UITableView()
    let commentInputView = UIView()
    let commentTextField = UITextField()
    let commentInputButton = UIButton(type: .custom)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyleForView()
        setLayoutForView()
        print(commentInputView.frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView() {
        postTableView.register(UINib(nibName: "PostContentTableViewCell", bundle: nil), forCellReuseIdentifier: "PostContentCell")
        postTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        postTableView.allowsSelection = false
        
        commentInputView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 48)
        
        commentTextField.attributedPlaceholder = NSAttributedString(
            string: "댓글을 입력하세요...",
            attributes:  [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        commentTextField.clearButtonMode = .whileEditing
        commentTextField.autocorrectionType = .no
        commentTextField.borderStyle = .roundedRect
        commentTextField.backgroundColor = .systemGray6
        
        commentInputButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        commentInputButton.tintColor = .systemBlue
        commentInputButton.backgroundColor = .systemRed
    }
    
    private func setLayoutForView() {
        self.addSubview(postTableView)
        self.addSubview(commentInputView)
        commentInputView.addSubview(commentTextField)
        commentInputView.addSubview(commentInputButton)
        
        postTableView.translatesAutoresizingMaskIntoConstraints = false
        commentInputView.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentInputButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            postTableView.bottomAnchor.constraint(equalTo: commentInputView.topAnchor),
            postTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            postTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            commentInputView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            commentInputView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            commentInputView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            commentTextField.heightAnchor.constraint(equalToConstant: 40),
            commentTextField.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            commentTextField.leadingAnchor.constraint(equalTo: commentInputView.leadingAnchor, constant: 5),
            
            commentInputButton.heightAnchor.constraint(equalToConstant: 40),
            commentInputButton.widthAnchor.constraint(equalToConstant: 40),
            commentInputButton.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            commentInputButton.leadingAnchor.constraint(equalTo: commentTextField.trailingAnchor, constant: 5)
        ])
    }
}
