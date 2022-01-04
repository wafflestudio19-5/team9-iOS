//
//  PostContentHeaderView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit
import RxSwift

class PostDetailHeaderView: UIStackView {
    
    /// 포스팅 상세페이지 상단의 게시글 뷰. 댓글 TableView의 헤더로 들어간다.
    
    private let contentLabel = PostContentLabel()
    let buttonStackView = InteractionButtonStackView(useBottomBorder: true)
    private let authorHeaderView = AuthorInfoHeaderView()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.numberOfLines = 40
        contentLabel.text = String(repeating: "테스트ㅡ트트트틑", count: 500)
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 이미지 그리드 뷰
    private let imageGridCollectionView = ImageGridCollectionView()
    
    // 좋아요 수 라벨
    private let likeCountLabel: UILabel = InfoLabel(color: .black, weight: .semibold)
    
    // 따봉 아이콘 + 좋아요 수
    private lazy var likeCountLabelWithIcon: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.addArrangedSubview(GradientIcon(width: .gradientIconWidth))
        stack.addArrangedSubview(likeCountLabel)
        return stack
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .Grayscales.gray2
        return divider
    }()
    
    func configure(with post: Post) {
        contentLabel.numberOfLines = 80
        contentLabel.text = String(repeating: post.content, count: 5000)
        likeCountLabel.text = post.likes.withCommas(unit: "개")
        authorHeaderView.configure(with: post)
        
        // TODO: duplicated lines
        let subpostUrls: [URL?] = post.subposts.map {
            guard let urlString = $0.file, let url = URL(string: urlString) else { return nil }
            return url
        }
        self.imageGridCollectionView.numberOfImages = post.subposts.count
//        Observable.just(subpostUrls)
//            .bind(to: imageGridCollectionView.rx.items(cellIdentifier: ImageGridCell.reuseIdentifier, cellType: ImageGridCell.self)) { row, data, cell in
//                cell.displayMedia(from: data)
//            }
//            .disposed(by: disposeBag)
    }
    
    func setLayout() {
        self.layoutMargins = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        self.isLayoutMarginsRelativeArrangement = true
        self.axis = .vertical
        self.spacing = .standardTopMargin
        self.alignment = .center
        
        self.addArrangedSubview(contentLabel)
        self.addArrangedSubview(imageGridCollectionView)
        self.addArrangedSubview(buttonStackView)
        self.addArrangedSubview(likeCountLabelWithIcon)
        self.addArrangedSubview(divider)
        
        NSLayoutConstraint.activate([
//            contentLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: .standardTopMargin + 5),
            contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .standardTrailingMargin),
            
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .standardTrailingMargin),
            
            likeCountLabelWithIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            likeCountLabelWithIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .standardTrailingMargin),
            
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        return
        
        self.addSubview(contentLabel)
        var trailing = contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .standardTrailingMargin)
//        trailing.priority = .defaultHigh
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: .standardTopMargin + 5),
            contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            trailing,
        ])
        
        self.addSubview(imageGridCollectionView)
        NSLayoutConstraint.activate([
            imageGridCollectionView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: .standardTopMargin),
            imageGridCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageGridCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        self.addSubview(buttonStackView)
        trailing = buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .standardTrailingMargin)
        trailing.priority = .defaultHigh
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: imageGridCollectionView.bottomAnchor, constant: .standardTopMargin),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            trailing,
            buttonStackView.heightAnchor.constraint(equalToConstant: .buttonGroupHeight),
        ])
        
        self.addSubview(likeCountLabelWithIcon)
        NSLayoutConstraint.activate([
            likeCountLabelWithIcon.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: .standardTopMargin),
            likeCountLabelWithIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            likeCountLabelWithIcon.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        self.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: likeCountLabelWithIcon.bottomAnchor, constant: .standardTopMargin),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    
    
}