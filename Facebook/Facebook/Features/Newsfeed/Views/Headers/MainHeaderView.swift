//
//  MainHeaderView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/01.
//

import Foundation
import UIKit

/// 뉴스피드 상단에 보이는 헤더 뷰를 관리한다.
class MainHeaderView: UIStackView {
    
    let createPostHeaderView = CreatePostHeaderView()
    let uploadProgressHeaderView = UploadProgressHeaderView()
    
    var createPostButton: UIButton {
        createPostHeaderView.createPostButton
    }
    
    var uploadProgressView: UIProgressView {
        uploadProgressHeaderView.progressView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        self.axis = .vertical
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(createPostHeaderView)
        self.addArrangedSubview(uploadProgressHeaderView)
    }
}
