//
//  GenderTableViewCell.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import UIKit

class GenderTableViewCell: UITableViewCell {

    static let genderTableViewCellID = "genderTableViewCell"
    
    private let titleLabel = UILabel()
    private let selectedImage = UIImage(systemName: "circle.fill")
    private let deselectedImage = UIImage(systemName: "circle")
    private let selectButton = UIImageView()
    
    override var isSelected: Bool {
        didSet {
            changeButtonState(to: isSelected)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        changeButtonState(to: false)
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLabelText(as text: String) {
        titleLabel.text = text
    }
    
    private func changeButtonState(to: Bool) {
        selectButton.image = (isSelected ? selectedImage : deselectedImage)
    }
    
    private func setStyleForView() {
        self.tintColor = FacebookColor.blue.color()
        self.selectionStyle = .none
        
        titleLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
    }
    
    private func setLayoutForView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 36.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36.0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            selectButton.widthAnchor.constraint(equalToConstant: 16.0),
            selectButton.heightAnchor.constraint(equalToConstant: 16.0),
            selectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36.0),
            selectButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
