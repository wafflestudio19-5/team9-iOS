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


protocol CreatePostTableViewCellDelegate: AnyObject {
    func goCreatePostView()
}

class CreatePostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var createPostButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bindButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    weak var delegate: CreatePostTableViewCellDelegate?
    
    private func bindButton() {
        createPostButton.rx.tap.bind {
            self.delegate?.goCreatePostView()
        }.disposed(by: disposeBag)
        
        profileImage.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            print("profileImage tap!")
        }).disposed(by: disposeBag)
    }
}
