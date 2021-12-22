//
//  ProfileImageTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/20.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
