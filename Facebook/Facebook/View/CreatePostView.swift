//
//  CreatePostView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/15.
//

import UIKit
import Kingfisher

class CreatePostView: UIView {
    
    let profileImage = UIImageView()
    let nameLabel = UILabel()
    let contentTextfield = UITextField()
    
    let postButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView() {
        profileImage.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "person.circle.fill")
        profileImage.image = image
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nameLabel.text = "writer"
        
        contentTextfield.attributedPlaceholder = NSAttributedString(
            string: "무슨 생각을 하고 계신가요?",
            attributes:  [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        postButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        postButton.setTitle("게시", for: .normal)
        postButton.setTitleColor(UIColor.lightGray, for: .normal)
        postButton.backgroundColor = .systemGray4
        postButton.layer.cornerRadius = 5
    }
    
    private func setLayoutForView() {
        self.addSubview(profileImage)
        self.addSubview(nameLabel)
        self.addSubview(contentTextfield)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            profileImage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
            contentTextfield.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            contentTextfield.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15)
        ])
    }
}
 
