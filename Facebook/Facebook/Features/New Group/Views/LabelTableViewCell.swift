//
//  SelfIntroTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/22.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var selfIntroLabel: UILabel!
    
    enum Style {
        case style1
        case style2
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStyle(style: Style) {
        switch style {
        case .style1:
            print("Styl")
        case .style2:
            print("Styl")
        }
    }
}
