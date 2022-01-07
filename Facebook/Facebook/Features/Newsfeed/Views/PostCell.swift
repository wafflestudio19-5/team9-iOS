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
    /// cell이 reuse될 때 `disposeBag`은 새로운 것으로 갈아끼워진다. 따라서 기존 cell의 구독이 취소된다.
    var disposeBag = DisposeBag()
    static let reuseIdentifier = "PostCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.width = UIScreen.main.bounds.width  // important for initial layout
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
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
        var copied = post
        copied.likes = response.likes
        copied.is_liked = response.is_liked
        post = copied  // 중복 업데이트 방지
    }
    
    // MARK: Setup
    
    func configureCell(with newPost: Post) {
        post = newPost
        commentCountButton.text = "댓글 \(post.comments.withCommas(unit: "개"))"
        textContentLabel.text = post.content
        postHeader.configure(with: post)
        
        // CollectionView Layout
        let subpostUrls: [URL?] = post.subposts!.map {
            guard let urlString = $0.file, let url = URL(string: urlString) else { return nil }
            return url
        }
        self.imageGridCollectionView.numberOfImages = post.subposts!.count
        Observable.just(subpostUrls)
            .observe(on: MainScheduler.instance)
            .bind(to: imageGridCollectionView.rx.items(cellIdentifier: ImageGridCell.reuseIdentifier, cellType: ImageGridCell.self)) { row, data, cell in
                cell.displayMedia(from: data)
            }
            .disposed(by: disposeBag)
        self.layoutIfNeeded()
    }
    
    // MARK: AutoLayout Constraints
    
    private func setLayout() {
        contentView.addSubview(postHeader)
        NSLayoutConstraint.activate([
            postHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .standardLeadingMargin),
            postHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .standardTrailingMargin),
            postHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .standardTopMargin),
            postHeader.heightAnchor.constraint(equalToConstant: .profileImageSize),
        ])
        
        contentView.addSubview(textContentLabel)
        NSLayoutConstraint.activate([
            textContentLabel.topAnchor.constraint(equalTo: postHeader.bottomAnchor, constant: .standardTopMargin),
            textContentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .standardLeadingMargin),
            textContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .standardTrailingMargin),
        ])
        
        contentView.addSubview(imageGridCollectionView)
        NSLayoutConstraint.activate([
            imageGridCollectionView.topAnchor.constraint(equalTo: textContentLabel.bottomAnchor, constant: .standardTopMargin),
            imageGridCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageGridCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        contentView.addSubview(statHorizontalStackView)
        NSLayoutConstraint.activate([
            statHorizontalStackView.topAnchor.constraint(equalTo: imageGridCollectionView.bottomAnchor, constant: .standardTopMargin),
            statHorizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .standardLeadingMargin),
            statHorizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .standardTrailingMargin),
            statHorizontalStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        contentView.addSubview(buttonHorizontalStackView)
        contentView.addSubview(divider)
        let top = buttonHorizontalStackView.topAnchor.constraint(equalTo: statHorizontalStackView.bottomAnchor, constant: .standardTopMargin)
        top.priority = .defaultHigh
        NSLayoutConstraint.activate([
            top,
            buttonHorizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .standardLeadingMargin),
            buttonHorizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .standardTrailingMargin),
            buttonHorizontalStackView.heightAnchor.constraint(equalToConstant: .buttonGroupHeight)
        ])
        
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: buttonHorizontalStackView.bottomAnchor),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 5),
        ])
    }
    
    // MARK: Initialize View Components
    
    // 이미지 그리드 뷰
    private let imageGridCollectionView = ImageGridCollectionView()
    
    // 포스트 헤더 (프로필 이미지, 작성자, 날짜, 각종 버튼이 들어가는 곳)
    let postHeader = AuthorInfoHeaderView()
    
    // 좋아요, 댓글, 공유 버튼 나란히 있는 스택 뷰
    let buttonHorizontalStackView = InteractionButtonStackView()
    
    // 좋아요 수, 댓글 수 등 각종 통계가 보이는 스택 뷰
    private lazy var statHorizontalStackView: UIStackView = {
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
    private let textContentLabel = PostContentLabel()
    
    // 피드와 피드 사이의 회색 리바이더
    private let divider = Divider(color: .grayscales.newsfeedDivider)
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
