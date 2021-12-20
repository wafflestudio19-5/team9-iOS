//
//  PostTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/25.
//

import UIKit
import RxSwift
import RxGesture

protocol PostTableViewCellDelegate: AnyObject {
    func goPostView()
}

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var writerImage: UIImageView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var commentButton: CommentButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bindCellTapGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: PostTableViewCellDelegate?
    
    private func bindCellTapGesture() {
        self.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            self?.delegate?.goPostView()
        }).disposed(by: disposeBag)
    }
}
