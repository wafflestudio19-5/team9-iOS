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
    
    var likeButton: LikeButton {
        return buttonStackView.likeButton
    }
    
    // Internal state that manages likes
    var likes: Int = 0 {
        didSet {
            likeCountLabel.text = likes.withCommas(unit: "개")
        }
    }
    var is_liked: Bool = false {
        didSet {
            likeButton.isSelected = is_liked
        }
    }

    /// 서버에 요청을 보내기 전에 UI를 업데이트한다.
    func like() {
        likes = is_liked ? max(0, likes - 1) : likes + 1
        is_liked = !is_liked
    }
    
    /// 서버에서 받은 응답에 따라 좋아요 개수를 동기화한다.
    func like(syncWith response: PostLikeResponse) {
        likes = response.likes
        is_liked = response.is_liked
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
    
    func configure(with post: Post) {
        likes = post.likes
        is_liked = post.is_liked
        contentLabel.text = post.content
        authorHeaderView.configure(with: post)
        
        
        // TODO: duplicated lines
        let subpostUrls: [URL?] = post.subposts.map {
            guard let urlString = $0.file, let url = URL(string: urlString) else { return nil }
            return url
        }
        imageGridCollectionView.numberOfImages = post.subposts.count
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
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .standardTrailingMargin),
            
            imageGridCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageGridCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .standardTrailingMargin),
            
            likeCountLabelWithIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .standardLeadingMargin),
            likeCountLabelWithIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .standardTrailingMargin)
        ])
    }
    
    
    
}
