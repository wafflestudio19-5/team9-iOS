//
//  EditProfileTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit
import RxSwift
import RxGesture
import RxCocoa

protocol EditProfileTableViewCellDelegate: AnyObject {
    func goEditProfileView()
}

class EditProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var editProfileButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editProfileButton.layer.cornerRadius = 5
        bindButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    weak var delegate: EditProfileTableViewCellDelegate?
    
    func bindButton() {
        editProfileButton.rx.tap.bind { _ in
            self.delegate?.goEditProfileView()
        }.disposed(by: disposeBag)
    }
}
