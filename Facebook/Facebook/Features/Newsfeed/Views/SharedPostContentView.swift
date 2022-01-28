//
//  SharedPostContentView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/23.
//

import UIKit
import RxSwift
import SnapKit

class SharedPostContentView: PostContentView {
    
    var fullWidthImageGrid: Bool
    
    init(fullWidthImageGrid: Bool) {
        self.fullWidthImageGrid = fullWidthImageGrid
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(sharing newPost: Post?) {
        guard let newPost = newPost else {
            toggle(forbidden: true)
            return
        }
        toggle(forbidden: false)
        
        post = newPost
        textContentLabel.text = post.content
        postHeader.configure(with: post)
        
        // CollectionView Layout
        configureImageGrid(with: newPost)
    }
    
    
    private func toggle(forbidden: Bool) {
        normalView.isHidden = forbidden
        forbiddenView.isHidden = !forbidden
    }
    
    private lazy var forbiddenView: UIView = ForbiddenShareContentView()
    
    private var normalView: UIView = {
       let view = UIView()
        return view
    }()
    
    private var borderView: UIView = {
        let borderView = UIView()
        borderView.layer.borderColor = UIColor.grayscales.imageBorder.cgColor
        borderView.layer.borderWidth = 1
        return borderView
    }()
    
    private var normalZeroHeight: Constraint?
    private var forbiddenZeroHeight: Constraint?
    
    override func setLayout() {
        self.addSubview(borderView)
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let stack = UIStackView(arrangedSubviews: [forbiddenView, normalView])
        stack.axis = .vertical
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        normalView.addSubview(postHeader)
        postHeader.ellipsisButton.isHidden = true
        postHeader.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CGFloat.standardLeadingMargin - 3)
            make.trailing.equalToSuperview().offset(CGFloat.standardTrailingMargin)
            make.top.equalToSuperview().offset(CGFloat.standardTopMargin)
            make.height.equalTo(CGFloat.profileImageSize)
        }
        
        normalView.addSubview(textContentLabel)
        textContentLabel.snp.makeConstraints { make in
            make.top.equalTo(postHeader.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalToSuperview().inset(CGFloat.standardLeadingMargin)
        }
        
        let imageGridInset: CGFloat = 10
        imageGridCollectionView.maxWidth = fullWidthImageGrid ? self.frame.width : self.frame.width - imageGridInset * 2
        normalView.addSubview(imageGridCollectionView)
        imageGridCollectionView.snp.makeConstraints { make in
            make.top.equalTo(textContentLabel.snp.bottom).offset(CGFloat.standardTopMargin)
            make.bottom.equalToSuperview().inset(imageGridInset).priority(.high)
            make.leading.trailing.equalToSuperview().inset(fullWidthImageGrid ? -imageGridInset : imageGridInset).priority(.high)
        }
        
    }

}
