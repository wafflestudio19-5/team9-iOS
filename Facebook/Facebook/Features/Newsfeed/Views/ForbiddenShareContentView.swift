//
//  ForbiddenShareContentView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/26.
//

import UIKit

class ForbiddenShareContentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubview(lockedImage)
        lockedImage.snp.makeConstraints { make in
            make.leading.equalTo(CGFloat.standardLeadingMargin)
            make.top.equalTo(CGFloat.standardTopMargin)
            make.height.equalTo(25)
        }
        
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.leading.equalTo(lockedImage.snp.trailing).offset(10)
            make.top.equalTo(CGFloat.standardTopMargin)
            make.trailing.equalTo(CGFloat.standardTrailingMargin)
        }
        
        self.addSubview(content)
        content.snp.makeConstraints { make in
            make.leading.equalTo(title.snp.leading)
            make.top.equalTo(title.snp.bottom).offset(3).priority(.high)
            make.bottom.equalTo(CGFloat.standardBottomMargin)
            make.trailing.equalTo(CGFloat.standardTrailingMargin)
        }
    }
    
    private let lockedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "lock.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))!.withTintColor(.label, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    private let title: InfoLabel = {
        let label = InfoLabel(color: .label, weight: .bold)
        label.text = "현재 이 콘텐츠를 이용할 수 없습니다."
        return label
    }()
    
    private let content: InfoLabel = {
        let label = InfoLabel(color: .label)
        label.numberOfLines = 0
        label.text = "일반적으로 소유자가 일부 사용자에게만 공유했거나, 공개 대상을 변경했거나, 콘텐츠를 삭제한 경우 이러한 문제가 발생합니다."
        return label
    }()
    
}
