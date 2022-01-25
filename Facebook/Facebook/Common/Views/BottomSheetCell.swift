//
//  BottomSheetCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/21.
//

import UIKit

class BottomSheetCell: UITableViewCell {

    static let reuseIdentifier = "BottomSheetCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(image: UIImage, text: String) {
        image.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))
        imgView.image = image
        label.text = text
    }
    
    private func setLayout() {
        contentView.addSubview(imgView)
        imgView.snp.remakeConstraints { make in
            make.height.width.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(label)
        label.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imgView.snp.right).offset(15)
        }
    }
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        imageView.tintColor = .black
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .center
        
        return imageView
    }()
    
    let label = UILabel()
}
