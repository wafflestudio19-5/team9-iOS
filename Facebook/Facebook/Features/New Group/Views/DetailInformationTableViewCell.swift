//
//  DetailInformationTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/30.
//

import UIKit
import RxSwift
import RxCocoa

class DetailInformationTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DetailInformationTableViewCell"
    
    var disposeBag = DisposeBag()
    
    enum Style {
        case style1
        case style2
        case style3
        case style4
    }
    
    var cellStyle: Style = .style1
    
    lazy var isIndicate = true
    
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
    
    func configureCell(image: UIImage, information: String, time: String = "", description: String = "", privacyBound: String = "") {
        switch self.cellStyle {
        case .style1:
            informationImage.image = image
            informationLabel.text = information
            descriptionLabel.text = description
        case .style2:
            informationImage.image = image
            informationLabel.text = information
            descriptionLabel.text = description
            privacyBoundLabel.text = privacyBound
        case .style3:
            informationImage.image = image
            informationLabel.text = information
            timeLabel.text = time
            privacyBoundLabel.text = privacyBound
            descriptionLabel.text = description
            
            editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        case .style4:
            informationImage.image = UIImage(systemName: "checkmark.square.fill")
            informationLabel.text = information
            descriptionLabel.text = "소개에 표시되지 않으며 전체 공개가 유지됩니다"
            editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            isIndicate = true
        }
    }
    
    func initialSetup(cellStyle: Style) {
        self.cellStyle = cellStyle
        setStyle()
        setLayout()
    }
    
    private func setStyle() {
        switch self.cellStyle {
        case .style1:
            informationImage.tintColor = .black
            descriptionLabel.textColor = .gray
        case .style2:
            informationImage.tintColor = .black
            descriptionLabel.textColor = .gray
        case .style3:
            descriptionLabel.textColor = .lightGray
            
            editButton.tintColor = .gray
        case .style4:
            informationImage.tintColor = .systemBlue
            descriptionLabel.textColor = .gray 
            editButton.tintColor = .black
        }
    }
    
    private func setLayout() {
        switch self.cellStyle {
        case .style1:
            addSubview(informationImage)
            informationImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                informationImage.heightAnchor.constraint(equalToConstant: 30),
                informationImage.widthAnchor.constraint(equalToConstant: 30),
                informationImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                informationImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
                informationImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
                informationImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
            ])
            
            addSubview(labelStackView)
            labelStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                labelStackView.leadingAnchor.constraint(equalTo: informationImage.trailingAnchor, constant: 15)
            ])
            
            labelStackView.addArrangedSubview(informationLabel)
            labelStackView.addArrangedSubview(descriptionLabel)
        case .style2:
            addSubview(informationImage)
            informationImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                informationImage.heightAnchor.constraint(equalToConstant: 30),
                informationImage.widthAnchor.constraint(equalToConstant: 30),
                informationImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
                informationImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
            ])
            
            addSubview(labelStackView)
            labelStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
                labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
                labelStackView.leadingAnchor.constraint(equalTo: informationImage.trailingAnchor, constant: 15)
            ])
            
            labelStackView.addArrangedSubview(informationLabel)
            labelStackView.addArrangedSubview(descriptionLabel)
            labelStackView.addArrangedSubview(privacyBoundLabel)
        case .style3:
            addSubview(informationImage)
            informationImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                informationImage.heightAnchor.constraint(equalToConstant: 30),
                informationImage.widthAnchor.constraint(equalToConstant: 30),
                informationImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
                informationImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
            ])
            
            addSubview(labelStackView)
            labelStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
                labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
                labelStackView.leadingAnchor.constraint(equalTo: informationImage.trailingAnchor, constant: 15)
            ])
            
            labelStackView.addArrangedSubview(informationLabel)
            labelStackView.addArrangedSubview(timeLabel)
            labelStackView.addArrangedSubview(privacyBoundLabel)
            labelStackView.addArrangedSubview(descriptionLabel)

            
            addSubview(editButton)
            editButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                editButton.heightAnchor.constraint(equalToConstant: 30),
                editButton.widthAnchor.constraint(equalToConstant: 30),
                editButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
            ])
        case .style4:
            addSubview(informationImage)
            informationImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                informationImage.heightAnchor.constraint(equalToConstant: 20),
                informationImage.widthAnchor.constraint(equalToConstant: 20),
                informationImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                informationImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
                informationImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
                informationImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
            ])
            
            addSubview(labelStackView)
            labelStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelStackView.heightAnchor.constraint(equalToConstant: 20),
                labelStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
                labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
                labelStackView.leadingAnchor.constraint(equalTo: informationImage.trailingAnchor, constant: 15)
            ])
            
            labelStackView.addArrangedSubview(informationLabel)
            
            addSubview(editButton)
            editButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                editButton.heightAnchor.constraint(equalToConstant: 25),
                editButton.widthAnchor.constraint(equalToConstant: 25),
                editButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
            ])
        }
    }
    
    func toggleIndicate() {
        if isIndicate {
            informationImage.image = UIImage(systemName: "square")!
            informationImage.tintColor = .darkGray
            labelStackView.addArrangedSubview(descriptionLabel)
            isIndicate = false
        } else {
            informationImage.image = UIImage(systemName: "checkmark.square.fill")!
            informationImage.tintColor = .systemBlue
            labelStackView.removeArrangedSubview(descriptionLabel)
            descriptionLabel.removeFromSuperview()
            isIndicate = true
        }
    }

    let informationImage = UIImageView()
    let informationLabel = UILabel()

    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        
        return stackView
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    lazy var privacyBoundLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        
        return label
    }()
    
    lazy var editButton = UIButton()
}
