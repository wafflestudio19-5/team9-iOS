//
//  BirthSelectTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/02.
//

import UIKit
import RxSwift
import RxCocoa

class BirthSelectTableViewCell: UITableViewCell {

    static let reuseIdentifier = "BirthSelectTableViewCell"
    
    var disposeBag = DisposeBag()
    
    enum Style {
        case birthDay
        case birthYear
    }
    
    var cellStyle: Style = .birthDay
    
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
        setLayout()
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
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10)
        ])
        
        switch self.cellStyle {
        case .birthDay:
            self.contentView.addSubview(monthSelectButton)
            NSLayoutConstraint.activate([
                monthSelectButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                monthSelectButton.leadingAnchor.constraint(equalTo: self.label.trailingAnchor, constant: 10)
            ])
        case .birthYear:
            break
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var monthSelectButton: UIButton = {
        let button = UIButton()
        button.setTitle("월 선택", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
}
