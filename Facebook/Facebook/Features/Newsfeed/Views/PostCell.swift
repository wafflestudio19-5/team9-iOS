//
//  PostCell.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/18.
//

import UIKit
import SwiftUI
import RxSwift

class PostCell: UITableViewCell {
    /// cell이 reuse될 때 `refreshingBag`은 새로운 것으로 갈아끼워진다. 따라서 기존 cell의 구독이 취소된다.
    var refreshingBag = DisposeBag()
    /// cell의 라이프사이클 전반에 걸쳐 유지되는 `DisposeBag`.
    var permanentBag = DisposeBag()
    class var reuseIdentifier: String { "PostCell" }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.width = UIScreen.main.bounds.width  // important for initial layout
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.refreshingBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use storyboard. Load programmatically.")
    }
    
    var likeButton: LikeButton {
        return buttonHorizontalStackView.likeButton
    }
    
    var post: Post = Post.getDummyPost() {
        didSet {
            likeCountLabel.text = post.likes.withCommas(unit: "개")
            likeButton.isSelected = post.is_liked
            commentCountButton.text = "댓글 \(post.comments.withCommas(unit: "개"))"
            layoutIfNeeded()
        }
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
    
    func configureCell(with newPost: Post, showGrid: Bool = true) {
        post = newPost
        textContentLabel.text = post.content
        postHeader.configure(with: post)
        
        if !showGrid {
            return
        }
        
        // CollectionView Layout
        self.imageGridCollectionView.numberOfImages = post.subposts!.count
        Observable.just(post.subpostUrls.prefix(5))
            .observe(on: MainScheduler.instance)
            .bind(to: imageGridCollectionView.rx.items(cellIdentifier: ImageGridCell.reuseIdentifier, cellType: ImageGridCell.self)) { row, data, cell in
                cell.displayMedia(from: data)
            }
            .disposed(by: refreshingBag)
        self.layoutIfNeeded()
    }
    
    // MARK: AutoLayout Constraints
    
    func setLayout() {
        contentView.addSubview(postHeader)
        postHeader.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(CGFloat.standardLeadingMargin - 3)
            make.trailing.equalTo(contentView).offset(CGFloat.standardTrailingMargin)
            make.top.equalTo(contentView).offset(CGFloat.standardTopMargin)
            make.height.equalTo(CGFloat.profileImageSize)
        }
        
        contentView.addSubview(textContentLabel)
        textContentLabel.snp.makeConstraints { make in
            make.top.equalTo(postHeader.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(contentView).inset(CGFloat.standardLeadingMargin)
        }
        
        contentView.addSubview(imageGridCollectionView)
        imageGridCollectionView.snp.makeConstraints { make in
            make.top.equalTo(textContentLabel.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(contentView)
        }
        
        contentView.addSubview(statHorizontalStackView)
        statHorizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(imageGridCollectionView.snp.bottom).offset(CGFloat.standardTopMargin)
            make.leading.trailing.equalTo(contentView).inset(CGFloat.standardLeadingMargin)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(buttonHorizontalStackView)
        buttonHorizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(statHorizontalStackView.snp.bottom).offset(CGFloat.standardTopMargin).priority(.high)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(CGFloat.buttonGroupHeight)
        }
        
        contentView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(buttonHorizontalStackView.snp.bottom)
            make.bottom.leading.trailing.equalTo(contentView)
            make.height.equalTo(5)
        }
    }
    
    // MARK: Initialize View Components
    
    // 이미지 그리드 뷰
    let imageGridCollectionView = ImageGridCollectionView()
    
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
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(likeCountLabelWithIcon)
        stack.addArrangedSubview(commentCountButton)
        return stack
    }()
    
    // 좋아요 수 라벨
    private let likeCountLabel: UILabel = InfoLabel()
    
    // 따봉 아이콘 + 좋아요 수
    private lazy var likeCountLabelWithIcon: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
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
}

/*
 MARK: SwiftUI Preview
 */

struct PostCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = PostCell().contentView
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct PostCellPreview: PreviewProvider {
    static var previews: some View {
        VStack{
            Spacer()
            PostCellRepresentable()
            Spacer()
        }.background(.white)
    }
}
