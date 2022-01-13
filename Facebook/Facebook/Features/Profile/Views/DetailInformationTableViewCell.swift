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
        resetCell()
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
        setStyle()
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
            
            editButton.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        case .style4:
            informationImage.image = UIImage(systemName: "checkmark.square.fill")
            informationLabel.text = information
            descriptionLabel.text = "소개에 표시되지 않으며 전체 공개가 유지됩니다"
            editButton.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
            isIndicate = true
        }
    }
    
    private func resetCell() {
        for view in self.contentView.subviews{
            view.removeFromSuperview()
        }
        
        informationLabel.text = ""
        descriptionLabel.text = ""
        timeLabel.text = ""
        privacyBoundLabel.text = ""
    }
    
    private func setStyle() {
        switch self.cellStyle {
        case .style1:
            informationImage.contentMode = .scaleAspectFit
            informationImage.layer.cornerRadius = 17.5
            informationImage.clipsToBounds = true
            informationImage.tintColor = .black
            
            descriptionLabel.textColor = .gray
        case .style2:
            informationImage.contentMode = .scaleAspectFit
            informationImage.layer.cornerRadius = 17.5
            informationImage.clipsToBounds = true
            informationImage.tintColor = .black
            
            descriptionLabel.textColor = .gray
        case .style3:
            informationImage.contentMode = .scaleAspectFit
            informationImage.layer.cornerRadius = 17.5
            informationImage.clipsToBounds = true
            
            descriptionLabel.textColor = .lightGray
            
            editButton.tintColor = .gray
        case .style4:
            informationImage.tintColor = .systemBlue
            descriptionLabel.textColor = .lightGray
            editButton.tintColor = .black
        }
    }
    
    private func setLayout() {
        switch self.cellStyle {
        case .style1:
            contentView.addSubview(informationImage)
            informationImage.snp.remakeConstraints { make in
                make.height.width.equalTo(35)
                make.top.bottom.equalTo(contentView).inset(10)
                make.leading.equalTo(contentView).inset(15)
            }
            
            contentView.addSubview(labelStackView)
            labelStackView.snp.remakeConstraints { make in
                make.centerY.equalTo(contentView)
                make.leading.equalTo(informationImage.snp.trailing).inset(-15)
            }
            
            labelStackView.addArrangedSubview(informationLabel)
            labelStackView.addArrangedSubview(descriptionLabel)
        case .style2:
            contentView.addSubview(informationImage)
            informationImage.snp.remakeConstraints { make in
                make.height.width.equalTo(35)
                make.top.equalTo(contentView).inset(CGFloat.standardTopMargin)
                make.leading.equalTo(contentView).inset(CGFloat.standardLeadingMargin)
            }
            
            contentView.addSubview(labelStackView)
            labelStackView.snp.remakeConstraints { make in
                make.centerY.equalTo(contentView)
                make.top.bottom.equalTo(contentView).inset(5)
                make.leading.equalTo(informationImage.snp.trailing).inset(-15)
            }
            
            labelStackView.addArrangedSubview(informationLabel)
            labelStackView.addArrangedSubview(descriptionLabel)
            labelStackView.addArrangedSubview(privacyBoundLabel)
        case .style3:
            contentView.addSubview(informationImage)
            informationImage.snp.remakeConstraints { make in
                make.height.width.equalTo(35)
                make.top.equalTo(contentView).inset(CGFloat.standardTopMargin)
                make.leading.equalTo(contentView).inset(CGFloat.standardLeadingMargin)
            }
            
            contentView.addSubview(labelStackView)
            labelStackView.snp.remakeConstraints { make in
                make.centerY.equalTo(contentView)
                make.top.bottom.equalTo(contentView).inset(5)
                make.leading.equalTo(informationImage.snp.trailing).inset(-15)
            }

            
            labelStackView.addArrangedSubview(informationLabel)
            labelStackView.addArrangedSubview(timeLabel)
            labelStackView.addArrangedSubview(privacyBoundLabel)
            labelStackView.addArrangedSubview(descriptionLabel)

            
            contentView.addSubview(editButton)
            editButton.snp.remakeConstraints { make in
                make.height.width.equalTo(30)
                make.top.equalTo(contentView).inset(CGFloat.standardTopMargin)
                make.trailing.equalTo(contentView).inset(15)
            }
        case .style4:
            contentView.addSubview(informationImage)
            informationImage.snp.remakeConstraints { make in
                make.centerY.equalTo(contentView)
                make.height.width.equalTo(20)
                make.top.bottom.leading.equalTo(contentView).inset(15)
            }
            
            
            contentView.addSubview(labelStackView)
            labelStackView.snp.remakeConstraints { make in
                make.centerY.equalTo(contentView)
                make.height.equalTo(20)
                make.top.bottom.equalTo(contentView).inset(5)
                make.leading.equalTo(informationImage.snp.trailing).inset(-15)
            }
            
            labelStackView.addArrangedSubview(informationLabel)
            
            contentView.addSubview(editButton)
            editButton.snp.remakeConstraints { make in
                make.height.width.equalTo(30)
                make.centerY.equalTo(contentView)
                make.trailing.equalTo(contentView).inset(15)
            }
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
