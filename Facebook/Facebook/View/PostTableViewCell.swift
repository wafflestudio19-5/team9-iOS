//
//  PostTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/25.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var writerImage: UIImageView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setButtonStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureLabels(with post: Post) {
        contentLabel.text = post.content
        likeLabel.text = String(post.likes)
    }
    
    func setButtonStyle() {
        let likeImageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
        likeButton.setImage(UIImage(systemName: "hand.thumbsup", withConfiguration: likeImageConfig), for: .normal)
        likeButton.titleLabel?.text = "싫어요"
        likeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
    }
}
