//
//  EditProfileTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit

protocol EditProfileTableViewCellDelegate: class {
    
}

class EditProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var editProfileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editProfileButton.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
        
    weak var deletegate: EditProfileTableViewCellDelegate?
}
