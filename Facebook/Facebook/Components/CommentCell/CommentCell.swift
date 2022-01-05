//
//  CommentCell.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/05.
//

import UIKit
import RxSwift
import RxGesture
import SwiftUI

class CommentCell: UITableViewCell {
    
    static let reuseIdentifier = "CommentCell"
    
    private let disposeBag = DisposeBag()
    private var leftMarginConstraint: NSLayoutConstraint?
    private var profileHeightConstraint: NSLayoutConstraint?
    private var profileWidthConstraint: NSLayoutConstraint?
    
    private var profileImageSize: CGFloat = 40 {
        didSet {
            self.profileWidthConstraint?.constant = profileImageSize
            self.profileHeightConstraint?.constant = profileImageSize
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CommentCell.reuseIdentifier)
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with comment: Comment) {
        authorLabel.text = comment.author.username
        contentLabel.text = String(repeating: comment.content, count: Int.random(in: 1...10))
        createdLabel.text = comment.posted_at
        profileImageSize = comment.profileImageSize
        leftMarginConstraint?.constant = comment.leftMargin
    }
    
    private func setLayout() {
        
        // 코멘트 작성자 이름과 코멘트 내용으로 이루어진 verticalStackForContents 와
        // 작성 시간, 좋아요 버튼, 답글 달기 버튼을 담고 있는 horizontalStackForButtons 으로 구성되어 있습니다.
        
        // verticalStackForContents로 따로 분리한 이유는 이 둘을 묶어 배경에 roundedRectangle이 있고 여기에 padding(inset)이 있는 형식으로 만들기 위함이었습니다. 로컬에서 초안처럼 생각나는대로 짜둔 구조라서 더 나은 구조가 있다면 변경하시면 됩니다.
        
        contentView.addSubview(profileImage)
        
        let horizontalStackForButtons = UIStackView()
        horizontalStackForButtons.axis = .horizontal
        horizontalStackForButtons.spacing = 17.0
        horizontalStackForButtons.addArrangedSubview(createdLabel)
        horizontalStackForButtons.addArrangedSubview(likesLabel)
        horizontalStackForButtons.addArrangedSubview(addChildCommentLabel)
        horizontalStackForButtons.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(horizontalStackForButtons)
        
        
        let verticalStackForContents = UIStackView()
        verticalStackForContents.axis = .vertical
        verticalStackForContents.spacing = 0
        verticalStackForContents.backgroundColor = FacebookColor.mildGray.color()
        verticalStackForContents.layer.cornerRadius = 18
        verticalStackForContents.isLayoutMarginsRelativeArrangement = true
        verticalStackForContents.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        verticalStackForContents.addArrangedSubview(authorLabel)
        verticalStackForContents.addArrangedSubview(contentLabel)
        verticalStackForContents.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(verticalStackForContents)
        
        leftMarginConstraint = profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .standardLeadingMargin - 5)
        profileHeightConstraint = profileImage.heightAnchor.constraint(equalToConstant: profileImageSize)
        profileWidthConstraint = profileImage.widthAnchor.constraint(equalToConstant: profileImageSize)
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .standardTopMargin),
            leftMarginConstraint!,
            profileHeightConstraint!,
            profileWidthConstraint!,
            
            verticalStackForContents.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .standardTopMargin),
            verticalStackForContents.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 4),
            verticalStackForContents.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: .standardTrailingMargin),
            
            horizontalStackForButtons.topAnchor.constraint(equalTo: verticalStackForContents.bottomAnchor, constant: 4),
            horizontalStackForButtons.leadingAnchor.constraint(equalTo: verticalStackForContents.leadingAnchor, constant: .standardLeadingMargin),
            horizontalStackForButtons.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func bind() {
        profileImage.rx.tapGesture().when(.recognized)
            .bind { [weak self] _ in
                print("profile Image tapped")
                // move to user profile view
            }.disposed(by: disposeBag)
        
        likesLabel.rx.tapGesture().when(.recognized)
            .bind { [weak self] _ in
                print("likeslabel tapped")
                // send POST request to server
            }.disposed(by: disposeBag)
        
        addChildCommentLabel.rx.tapGesture().when(.recognized)
            .bind { [weak self] _ in
                print("답글 달기 tapped")
                // add some action for creating child comment
            }.disposed(by: disposeBag)
    }
    
    // MARK: UI Components
    
    private let profileImage = ProfileImageView()
    private let authorLabel = InfoLabel(color: .black, size: 14, weight: .medium)
    private let contentLabel: UILabel = {
        let label = InfoLabel(color: .black, size: 16, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakStrategy = .pushOut
        return label
    }()
    private let createdLabel = InfoLabel(color: .darkGray, size: 12, weight: .regular)
    
    private lazy var likesLabel: UILabel = {
        let label = InfoLabel(color: .darkGray, size: 12, weight: .medium)
        label.text = "좋아요"
        return label
    }()
    
    private lazy var addChildCommentLabel: UILabel = {
        let label = InfoLabel(color: .darkGray, size: 12, weight: .medium)
        label.text = "답글 달기"
        return label
    }()
}

struct CommentCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = CommentCell().contentView
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct CommentCellPreview: PreviewProvider {
    static var previews: some View {
        VStack{
            Spacer()
            CommentCellRepresentable()
            Spacer()
        }.preferredColorScheme(.light).previewDevice("iPhone 12 Pro").background(.white)
    }
}
