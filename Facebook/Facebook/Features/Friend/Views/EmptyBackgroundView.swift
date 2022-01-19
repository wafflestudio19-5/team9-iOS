//
//  EmptyBackgroundView.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/19.
//
//친구 또는 친구 요청 tableview 데이터가 없을 때 나타나는 뷰입니다.
import UIKit

class EmptyBackgroundView: UIView {

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .darkGray
        
        return label
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0 
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(image: UIImage, title: String, message: String) {
        super.init(frame: .zero)
        setLayout()
        setupComponents(image: image, title: title, message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(30)
        }

        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(50)
        }
    }
    
    private func setupComponents(image: UIImage, title: String, message: String) {
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
    }
}
