//
//  DetailProfileTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleInformationTableViewCell: UITableViewCell { 

    static let reuseIdentifier = "SimpleInformationTableViewCell"
    
    var disposeBag = DisposeBag()
    
    enum Style {
        case style1
        case style2
        case style3
        case style4
    }
    
    var cellStyle: Style = .style1
    
    lazy var informationIsSelected: Bool = false
    
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
    
    func configureCell(image: UIImage, information: String) {
        informationImage.image = image
        informationLabel.text = information
    }
    
    func initialSetup(cellStyle: Style) {
        self.cellStyle = cellStyle

        setLayout()
        setStyle()
    }
    
    private func setStyle(){
        switch self.cellStyle {
        case .style1:
            informationImage.tintColor = .darkGray
            
            informationLabel.font = UIFont.systemFont(ofSize: 18)
        case .style2:
            informationImage.tintColor = .gray
            
            informationLabel.font = UIFont.systemFont(ofSize: 18)
        case .style3:
            informationImage.contentMode = .scaleAspectFit
            informationImage.layer.cornerRadius = 17.5
            informationImage.clipsToBounds = true
            informationImage.tintColor = .gray
            
            informationLabel.font = UIFont.systemFont(ofSize: 18)
            informationLabel.textColor = .systemBlue
        case .style4:
            informationImage.contentMode = .scaleAspectFit
            informationImage.layer.cornerRadius = 17.5
            informationImage.clipsToBounds = true
            informationImage.layer.borderColor = CGColor(gray: 1, alpha: 1)
            informationImage.layer.borderWidth = 1
            informationImage.tintColor = .gray
            
            informationLabel.font = UIFont.systemFont(ofSize: 20)
            informationLabel.textColor = .lightGray
        }
    }
    
    private func setLayout() {
        switch self.cellStyle {
        case .style1, .style2:
            addSubview(informationImage)
            informationImage.translatesAutoresizingMaskIntoConstraints = false
            informationImage.snp.remakeConstraints { make in
                make.height.width.equalTo(20)
                make.centerY.equalTo(self)
                make.top.bottom.equalTo(self).inset(CGFloat.standardTopMargin)
                make.leading.equalTo(self).inset(CGFloat.standardLeadingMargin)
            }
            
            addSubview(informationLabel)
            informationLabel.translatesAutoresizingMaskIntoConstraints = false
            informationLabel.snp.remakeConstraints { make in
                make.centerY.equalTo(self)
                make.leading.equalTo(informationImage.snp.trailing).inset(CGFloat.standardTrailingMargin)
            }
        case .style3:
            addSubview(informationImage)
            informationImage.translatesAutoresizingMaskIntoConstraints = false
            informationImage.snp.remakeConstraints { make in
                make.height.width.equalTo(35)
                make.centerY.equalTo(self)
                make.top.bottom.equalTo(self).inset(CGFloat.standardTopMargin)
                make.leading.equalTo(self).inset(CGFloat.standardLeadingMargin)
            }
            
            addSubview(informationLabel)
            informationLabel.translatesAutoresizingMaskIntoConstraints = false
            informationLabel.snp.remakeConstraints { make in
                make.centerY.equalTo(self)
                make.leading.equalTo(informationImage.snp.trailing).inset(CGFloat.standardTrailingMargin)
            }
        case .style4:
            self.contentView.addSubview(informationImage)
            informationImage.translatesAutoresizingMaskIntoConstraints = false
            informationImage.snp.remakeConstraints { make in
                make.height.width.equalTo(35)
                make.centerY.equalTo(self)
                make.top.bottom.equalTo(self).inset(CGFloat.standardTopMargin)
                make.leading.equalTo(self).inset(CGFloat.standardLeadingMargin)
            }
            
            self.contentView.addSubview(informationLabel)
            informationLabel.translatesAutoresizingMaskIntoConstraints = false
            informationLabel.snp.remakeConstraints { make in
                make.centerY.equalTo(self)
                make.leading.equalTo(informationImage.snp.trailing).inset(CGFloat.standardTrailingMargin)
            }
            
            self.contentView.addSubview(deleteButton)
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            deleteButton.snp.remakeConstraints { make in
                make.height.width.equalTo(35)
                make.centerY.equalTo(self)
                make.trailing.equalTo(self).inset(CGFloat.standardLeadingMargin)
            }
            deleteButton.isHidden = true
        }
    }
    
    let informationImage = UIImageView()
    let informationLabel = UILabel()

    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .gray
        
        return button
    }()
}
