//
//  DetailProfileTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit
import RxSwift
import RxCocoa

class DetailProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var informationImage: UIImageView!
    @IBOutlet weak var informationLabel: UILabel!

    let disposesBag = DisposeBag()
    
    enum Style {
        case style1
        case style2
        case style3
        case style4
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(style: Style) {
        switch style {
        case .style1:
            NSLayoutConstraint.activate([
                informationImage.heightAnchor.constraint(equalToConstant: 20),
                informationImage.widthAnchor.constraint(equalToConstant: 20)
            ])
        case .style2:
            NSLayoutConstraint.activate([
                informationImage.heightAnchor.constraint(equalToConstant: 20),
                informationImage.widthAnchor.constraint(equalToConstant: 20)
            ])
        case .style3:
            NSLayoutConstraint.activate([
                informationImage.heightAnchor.constraint(equalToConstant: 30),
                informationImage.widthAnchor.constraint(equalToConstant: 30)
            ])
            informationImage.layer.cornerRadius = informationImage.frame.width / 2
            informationImage.clipsToBounds = true
            informationImage.backgroundColor = .systemGray4
            informationImage.tintColor = .gray
        case .style4:
            NSLayoutConstraint.activate([
                informationImage.heightAnchor.constraint(equalToConstant: 30),
                informationImage.widthAnchor.constraint(equalToConstant: 30)
            ])
            informationImage.layer.cornerRadius = informationImage.frame.width / 2
            informationImage.clipsToBounds = true
            informationImage.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
            informationImage.layer.borderWidth - 0.5
            informationImage.backgroundColor = .systemGray2
            informationImage.tintColor = .gray
        }
    }
}
