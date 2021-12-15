//
//  MainProfileTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit
import RxSwift

protocol MainProfileTableViewCellDelegate: AnyObject {
    func goEditProfileView()
}

class MainProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editProfileButton.layer.cornerRadius = 5
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        
        bindButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    weak var delegate: MainProfileTableViewCellDelegate?
    
    func bindButton() {
        editProfileButton.rx.tap.bind { _ in
            self.delegate?.goEditProfileView()
        }.disposed(by: disposeBag)
    }
}
