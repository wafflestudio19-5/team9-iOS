//
//  GenderSelectTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/02.
//

import UIKit
import RxSwift
import RxCocoa

class GenderSelectTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "GenderSelectTableViewCell"
    
    enum Style {
        case male
        case female
    }
    
    var cellStyle: Style = .male
    
    var disposeBag = DisposeBag()
    
    var selectedGender = ""

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
    
    func initialSetup(cellStyle: Style, selectedGender: String) {
        self.cellStyle = cellStyle
        self.selectedGender = selectedGender
        setLayout()
        bindImage()
    }
    
    func configureCell(genderText: String) {
        genderLabel.text = genderText
    }
    
    private func setLayout() {
        self.addSubview(genderLabel)
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            genderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            genderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            genderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
        
        self.addSubview(isSelectImage)
        isSelectImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            isSelectImage.heightAnchor.constraint(equalToConstant: 25),
            isSelectImage.widthAnchor.constraint(equalToConstant: 25),
            isSelectImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            isSelectImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    private func bindImage() {
        //선택 여부에 따라 image 활성/비활성
        Observable.just(selectedGender).subscribe(onNext: { [weak self] selectedGender in
            guard let self = self else { return }
            
            switch selectedGender {
            case "M":
                switch self.cellStyle {
                case .male:
                    self.isSelectImage.image = UIImage(systemName: "checkmark")
                case .female:
                    self.isSelectImage.image = UIImage()
                }
            case "F":
                switch self.cellStyle {
                case .male:
                    self.isSelectImage.image = UIImage()
                case .female:
                    self.isSelectImage.image = UIImage(systemName: "checkmark")
                }
            default:
                break
            }
        }).disposed(by: disposeBag)
    }

    let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    let isSelectImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemBlue
        
        return imageView
    }()
}
