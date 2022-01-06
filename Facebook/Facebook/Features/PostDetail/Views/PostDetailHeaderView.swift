//
//  PostContentHeaderView.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import UIKit
import RxSwift
import RxRelay
import SwiftUI
import SnapKit

class PostDetailHeaderView: UIStackView {
    
    /// 포스팅 상세페이지 상단의 게시글 뷰. 댓글 TableView의 헤더로 들어간다.
    
    private let contentLabel = PostContentLabel()
    let buttonStackView = InteractionButtonStackView(useBottomBorder: true)
    private let authorHeaderView = AuthorInfoHeaderView()
    private let disposeBag = DisposeBag()
    
    /// 현재 뷰에서 포스트를 업데이트(좋아요 등)하면 이 `PublishRelay`를 구독한 뷰에서도 업데이트할 수 있다.
    let postUpdated = PublishRelay<Post>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var likeButton: LikeButton {
        return buttonStackView.likeButton
    }
    
    var post: Post = Post.getDummyPost() {
        didSet {
            likeCountLabel.text = post.likes.withCommas(unit: "개")
            likeButton.isSelected = post.is_liked
        }
    }
    
    // MARK: Like Button

    /// 서버에 요청을 보내기 전에 UI를 업데이트한다.
    func like() {
        var copied = post
        copied.likes = post.is_liked ? max(0, post.likes - 1) : post.likes + 1
        copied.is_liked = !post.is_liked
        post = copied
        if copied.is_liked {
            HapticManager.shared.impact(style: .light)
        }
    }
    
    /// 서버에서 받은 응답에 따라 좋아요 개수를 동기화한다.
    func like(syncWith response: LikeResponse) {
        var copied = post
        copied.likes = response.likes
        copied.is_liked = response.is_liked
        post = copied
        postUpdated.accept(post)
    }
    
    // 이미지 그리드 뷰
    private let imageGridCollectionView = ImageGridCollectionView()
    
    // 좋아요 수 라벨
    private let likeCountLabel: UILabel = InfoLabel(color: .grayscales.label, weight: .semibold)
    
    // 따봉 아이콘 + 좋아요 수
    private lazy var likeCountLabelWithIcon: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.addArrangedSubview(GradientIcon(width: .gradientIconWidth))
        stack.addArrangedSubview(likeCountLabel)
        return stack
    }()
    
    let loadPreviousButton = InfoButton(text: "이전 댓글 보기...", color: .label, weight: .semibold)
    private lazy var spinner = Spinner(frame: .init(x: 0, y: 0, width: self.frame.width, height: 100))
    
    lazy var loadButtonHStack: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .vertical
        hStack.alignment = .leading
        hStack.addArrangedSubview(loadPreviousButton)
        return hStack
    }()
    
    func configure(with newPost: Post) {
        post = newPost
        contentLabel.text = post.content
        authorHeaderView.configure(with: post)
        
        // TODO: duplicated lines
        let subpostUrls: [URL?] = post.subposts!.map {
            guard let urlString = $0.file, let url = URL(string: urlString) else { return nil }
            return url
        }
        imageGridCollectionView.numberOfImages = post.subposts!.count
        imageGridCollectionView.dataSource = nil
        Observable.just(subpostUrls)
            .bind(to: imageGridCollectionView.rx.items(cellIdentifier: ImageGridCell.reuseIdentifier, cellType: ImageGridCell.self)) { row, data, cell in
                cell.displayMedia(from: data)
            }
            .disposed(by: disposeBag)
    }
    
    func setLayout() {
        self.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.isLayoutMarginsRelativeArrangement = true
        self.axis = .vertical
        self.spacing = .standardTopMargin
        self.alignment = .center
        
        self.addArrangedSubview(contentLabel)
        self.addArrangedSubview(imageGridCollectionView)
        self.addArrangedSubview(buttonStackView)
        self.addArrangedSubview(likeCountLabelWithIcon)
        self.addArrangedSubview(loadButtonHStack)
        self.addArrangedSubview(spinner)
        
        let stretchHorizontal = { (make: ConstraintMaker) -> Void in
            make.leading.equalTo(CGFloat.standardLeadingMargin)
            make.trailing.equalTo(CGFloat.standardTrailingMargin)
        }
        
        contentLabel.snp.makeConstraints { make in
            stretchHorizontal(make)
        }
        
        imageGridCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(0)
        }
        
        buttonStackView.snp.makeConstraints { make in
            stretchHorizontal(make)
            make.height.equalTo(CGFloat.buttonGroupHeight)
        }
        
        likeCountLabelWithIcon.snp.makeConstraints { make in
            stretchHorizontal(make)
        }
        
        loadButtonHStack.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        
        spinner.snp.makeConstraints { make in
            make.height.equalTo(23)
        }
    }
    
    func showLoadingSpinner() {
        spinner.isHidden = false
        loadButtonHStack.isHidden = true
        
    }
    
    func hideLoadingSpinner() {
        spinner.isHidden = true
    }
}
