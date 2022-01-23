//
//  CreatePostTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class CreatePostTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CreatePostCell"
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var createPostButton: UIButton!
    
    private let divider = Divider(color: .grayscales.newsfeedDivider)
    
    let disposeBag = DisposeBag()
    
    private func setLayout() {
        contentView.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 5),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindButton()
        setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    private func bindButton() {
        profileImage.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            print("profileImage tap!")
        }).disposed(by: disposeBag)
    }
}
