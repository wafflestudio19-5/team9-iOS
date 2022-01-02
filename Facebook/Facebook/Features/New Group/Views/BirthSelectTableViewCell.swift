//
//  BirthSelectTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/02.
//

import UIKit

class BirthSelectTableViewCell: UITableViewCell {

    enum Style {
        case birthDay
        case birthYear
    }
    
    var cellStyle: Style = .birthDay
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialSetup(cellStyle: Style) {
        self.cellStyle = cellStyle
    }
    
    func configureCell() {
        switch self.cellStyle{
        case .birthDay:
            label.text = "생일"
        case .birthYear:
            label.text = "태어난 연도"
        }
    }
    
    private func setLayout() {
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10)
        ])
        
        switch self.cellStyle {
        case .birthDay:
            break
        case .birthYear:
            break
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    lazy var daySelectButton = UIButton
}
