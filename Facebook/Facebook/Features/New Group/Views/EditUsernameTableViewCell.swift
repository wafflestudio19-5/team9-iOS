//
//  EditUsernameTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa

class EditUsernameTableViewCell: UITableViewCell {

    static let reuseIdentifier = "EditUsernameTableViewCell"
    
    var disposeBag = DisposeBag()
    
    var isSelect: Bool = true

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
    
    func configureCell(username: String) {
        nameLabel.text = username
        setLayout()
    }
    
    private func setLayout() {
        self.contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
        
        self.contentView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(addImage)
        addImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            addImage.heightAnchor.constraint(equalToConstant: 20),
            addImage.widthAnchor.constraint(equalToConstant: 20),
            addImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            addImage.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -5)
        ])
    }

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    let addImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "plus")!)
        image.tintColor = .systemBlue
        
        return image
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("이름 변경", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return button
    }()
}
