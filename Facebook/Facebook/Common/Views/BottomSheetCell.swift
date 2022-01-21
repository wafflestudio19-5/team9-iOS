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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        image.image = UIImage(systemName: "person.crop.circle.fill.badge.xmark")
        label.text = "이 친구 차단"
    }
    
    private func setLayout() {
        addSubview(image)
        image.snp.remakeConstraints { make in
            make.height.width.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(5)
        }
        
        addSubview(label)
        label.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(image.snp.right).offset(15)
        }
    }
    
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.tintColor = .systemGray4
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let label = UILabel()
}
