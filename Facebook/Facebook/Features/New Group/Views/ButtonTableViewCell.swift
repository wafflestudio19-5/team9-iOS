//
//  EditProfileTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ButtonTableViewCell"
    
    enum Style {
        case style1
        case style2
        case style3
    }
    
    var cellStyle: Style = .style1
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(buttonText: String) {
        button.setTitle(buttonText, for: .normal)
    }
    
    func initialSetup(cellStyle: Style) {
        button.setTitle("initial text", for: .normal)
        self.cellStyle = cellStyle
        setStyle()
        setLayout()
    }
    
    
    private func setStyle() {
        button.layer.cornerRadius = 5
        
        switch self.cellStyle {
        case .style1:
            button.backgroundColor = FacebookColor.mildBlue.color()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(.systemBlue, for: .normal)
        case .style2:
            button.backgroundColor = FacebookColor.mildBlue.color()
            if let buttonImage = UIImage(systemName: "person.text.rectangle") {
                button.setImage(buttonImage, for: .normal)
                button.tintColor = .systemBlue
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            }
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            button.setTitleColor(.systemBlue, for: .normal)
        case .style3:
            button.backgroundColor = .systemGray3
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(.black, for: .normal)
        }
    }
    
    private func setLayout() {
        self.contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 35),
            button.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            button.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            button.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
    }
    
    let button = UIButton()
}
