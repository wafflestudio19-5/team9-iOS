//
//  FriendCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/13.
//

import UIKit
import RxSwift

class FriendCell: UITableViewCell {
    
    var refreshingBag = DisposeBag()
    var permanentBag = DisposeBag()
    static let reuseIdentifier = "FriendCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.width = UIScreen.main.bounds.width  // important for initial layout
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.refreshingBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        contentView.addSubview(profileImage)
        profileImage.snp.remakeConstraints { make in
            make.height.width.equalTo(50)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(CGFloat.standardLeadingMargin)
        }
        profileImage.layer.cornerRadius = 25
        
        contentView.addSubview(verticalStackView)
        verticalStackView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(15)
        }
        
        verticalStackView.addArrangedSubview(nameLabel)
        
        contentView.addSubview(menuButton)
        menuButton.snp.remakeConstraints { make in
            make.height.width.equalTo(30)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
        }
    }

    private let profileImage = UIImageView()
    private let verticalStackView = UIStackView()
    private let nameLabel = UILabel()
    private let withFriendLabel = UILabel()
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
    
        return button
    }()
}
