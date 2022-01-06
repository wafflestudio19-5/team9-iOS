//
//  SelfIntroTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/22.
//

import UIKit
import RxSwift
import RxCocoa

class LabelTableViewCell: UITableViewCell {

    static let reuseIdentifier = "LabelTableViewCell"
    
    var disposeBag = DisposeBag()
    
    enum Style {
        case style1
        case style2
    }
    
    var cellStyle: Style = .style1
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
          disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }
    
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
        setStyle()
        setLayout()
    }
    
    func configureCell(labelText: String) {
        label.text = labelText
    }
    
    private func setStyle() {
        switch self.cellStyle {
        case .style1:
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = .gray
        case .style2:
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .gray
        }
    }
    
    private func setLayout() {
        switch self.cellStyle {
        case .style1:
            self.contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ])
        case .style2:
            self.contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
                label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
            ])
        }
    }
    
    let label = UILabel()
}
