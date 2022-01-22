//
//  Postself.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/22.
//

import UIKit
import RxSwift
import Kingfisher

class PostContentView: UIView {

    private let disposeBag = DisposeBag()
    
    var post: Post = Post.getDummyPost() {
        didSet {
            likeCountLabel.text = post.likes.withCommas(unit: "개")
            likeButton.isSelected = post.is_liked
            commentCountButton.text = "댓글 \(post.comments.withCommas(unit: "개"))"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.width = UIScreen.main.bounds.width  // important for initial layout
        self.backgroundColor = .systemBackground
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Like Button

    /// 서버에 요청을 보내기 전에 UI를 업데이트한다.
    func like() {
        var copied = post
        copied.likes = post.is_liked ? max(0, post.likes - 1) : post.likes + 1
        copied.is_liked = !post.is_liked
        post = copied  // 중복 업데이트 방지
        if copied.is_liked {
            HapticManager.shared.impact(style: .light)
        }
    }
    
    /// 서버에서 받은 응답에 따라 좋아요 개수를 동기화한다.
    func like(syncWith response: LikeResponse) {
        StateManager.of.post.dispatch(post, syncWith: response)
    }
    
    // MARK: Setup
    
    func configure(with newPost: Post, showGrid: Bool = true) {
        post = newPost
        textContentLabel.text = post.content
        postHeader.configure(with: post)
        
        if !showGrid {
            return
        }
        
        // CollectionView Layout
        self.imageGridCollectionView.numberOfImages = post.subposts!.count
        imageGridCollectionView.dataSource = nil
        Observable.just(post.subpostUrls.prefix(5))
            .observe(on: MainScheduler.instance)
            .bind(to: imageGridCollectionView.rx.items(cellIdentifier: ImageGridCell.reuseIdentifier, cellType: ImageGridCell.self)) { row, data, cell in
                cell.displayMedia(from: data)
            }
            .disposed(by: disposeBag)
        
        imageGridCollectionView.snp.updateConstraints { make in
            make.top.equalTo(textContentLabel.snp.bottom).offset(imageGridCollectionView.numberOfImages == 0 ? 0 : CGFloat.standardTopMargin)
        }
        
        if let _ = self as? SharingPostContentView {
            return  // prevent recursive loop
        }
        
        if post.is_sharing ?? false {
            sharedPostView.isHidden = false
            sharedPostView.configure(with: post.postToShare)
            sharedPostView.snp.remakeConstraints { make in
                make.top.equalTo(imageGridCollectionView.snp.bottom).offset(CGFloat.standardTopMargin)
                make.leading.trailing.equalTo(0).inset(10)
            }
        } else {
            sharedPostView.isHidden = true
            sharedPostView.snp.remakeConstraints { make in
                make.top.equalTo(imageGridCollectionView.snp.bottom)
                make.leading.trailing.equalTo(0).inset(10)
                make.height.equalTo(0)
            }
        }
    }
    
    // MARK: AutoLayout Constraints
    
    func setLayout() {
        setUpperLayout()
        setLowerLayout()
    }
    
    func setUpperLayout() {
        self.addSubview(postHeader)
        postHeader.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(CGFloat.standardLeadingMargin - 3)
            make.trailing.equalTo(self).offset(CGFloat.standardTrailingMargin)
            make.top.equalTo(self).offset(CGFloat.standardTopMargin)
            make.height.equalTo(CGFloat.profileImageSize)
        }
        
        self.addSubview(textContentLabel)
        textContentLabel.snp.makeConstraints { make in
            make.top.equalTo(postHeader.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(self).inset(CGFloat.standardLeadingMargin)
        }
        
        self.addSubview(imageGridCollectionView)
        imageGridCollectionView.snp.makeConstraints { make in
            make.top.equalTo(textContentLabel.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(self)
        }
        
        self.addSubview(sharedPostView)
        sharedPostView.snp.remakeConstraints { make in
            make.top.equalTo(imageGridCollectionView.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(0).inset(10)
        }
        
        self.addSubview(statHorizontalStackView)
        statHorizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(sharedPostView.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(self).inset(CGFloat.standardLeadingMargin)
            make.height.equalTo(20)
        }
    }
    
    func setLowerLayout() {
        self.addSubview(buttonHorizontalStackView)
        buttonHorizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(statHorizontalStackView.snp.bottom).offset(CGFloat.standardTopMargin).priority(.high)
            make.leading.trailing.equalTo(self).inset(10)
            make.height.equalTo(CGFloat.buttonGroupHeight)
        }
        
        self.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(buttonHorizontalStackView.snp.bottom)
            make.bottom.leading.trailing.equalTo(self)
            make.height.equalTo(5)
        }
    }
    
    // MARK: Initialize View Components
    
    lazy var sharedPostView = SharingPostContentView()
    
    // 이미지 그리드 뷰
    lazy var imageGridCollectionView = ImageGridCollectionView()
    
    // 포스트 헤더 (프로필 이미지, 작성자, 날짜, 각종 버튼이 들어가는 곳)
    let postHeader = AuthorInfoHeaderView()
    
    // 좋아요, 댓글, 공유 버튼 나란히 있는 스택 뷰
    let buttonHorizontalStackView = InteractionButtonStackView()
    
    // 좋아요 수, 댓글 수 등 각종 통계가 보이는 스택 뷰
    lazy var statHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        stack.alignment = .center
        stack.addArrangedSubview(likeCountLabelWithIcon)
        stack.addArrangedSubview(commentCountButton)
        return stack
    }()
    
    // 좋아요 수 라벨
    private let likeCountLabel: UILabel = InfoLabel()
    
    // 따봉 아이콘 + 좋아요 수
    private lazy var likeCountLabelWithIcon: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.addArrangedSubview(GradientIcon(width: .gradientIconWidth))
        stack.addArrangedSubview(likeCountLabel)
        return stack
    }()
    
    // 댓글 수 라벨
    let commentCountButton: InfoButton = InfoButton()
    
    // 본문 텍스트 라벨
    let textContentLabel = PostContentLabel()
    
    // 피드와 피드 사이의 회색 리바이더
    let divider = Divider(color: .grayscales.newsfeedDivider)
    
    var likeButton: LikeButton {
        return buttonHorizontalStackView.likeButton
    }
}
