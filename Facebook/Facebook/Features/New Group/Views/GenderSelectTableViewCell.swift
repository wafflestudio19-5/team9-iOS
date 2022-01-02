//
//  GenderSelectTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/02.
//

import UIKit

class GenderSelectTableViewCell: UITableViewCell {

    var isSelect: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setLayout() {
        self.addSubview(genderLabel)
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            genderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            genderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            genderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
        
        self.addSubview(isSelectImage)
        isSelectImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            isSelectImage.heightAnchor.constraint(equalToConstant: 25),
            isSelectImage.widthAnchor.constraint(equalToConstant: 25),
            isSelectImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            isSelectImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }

    let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    let isSelectImage = UIImageView()
}
