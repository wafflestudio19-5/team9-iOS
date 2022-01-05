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
    
    private let profileImage = UIImageView()
    private let authorLabel = UILabel()
    private let contentLabel = UILabel()
    private let createdLabel = UILabel()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아요"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        return label
    }()
    
    private lazy var addChildCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "답글 달기"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CommentCell.reuseIdentifier)
        
        // 서버와의 연결이 이루어진 뒤에는 아래 코드를 지우고, convenience init만 이용하시면 됩니다
        setStyleForView()
        setLayoutForView()
        bind()
    }
    
    convenience init(comment: Comment) {
        self.init(style: .default, reuseIdentifier: CommentCell.reuseIdentifier)
        setStyleForView()
        setLayoutForView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView() {
        authorLabel.font = .systemFont(ofSize: 12.0, weight: .semibold)
        contentLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakStrategy = .pushOut
        createdLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        
        createdLabel.textColor = .darkGray
        
        
        // 서버와의 연동은 구현하지 않아서 sample text 넣어둡니다
        authorLabel.text = "김와플"
        contentLabel.text = "팀 회의는 매주 월요일 오후 9시입니다 팀 회의는 매주 월요일 오후 9시입니다 팀 회의는 매주 월요일 오후 9시입니다 팀 회의는 매주 월요일 오후 9시입니다 팀 회의는 매주 월요일 오후 9시입니다"
        createdLabel.text = "12시간"
        
        
        profileImage.contentMode = .scaleAspectFill
        profileImage.tintColor = FacebookColor.gray.color()
        profileImage.layer.cornerRadius = 18.0
        profileImage.image = UIImage(systemName: "person.crop.circle.fill")
    }
    
    private func setLayoutForView() {
        
        // 코멘트 작성자 이름과 코멘트 내용으로 이루어진 verticalStackForContents 와
        // 작성 시간, 좋아요 버튼, 답글 달기 버튼을 담고 있는 horizontalStackForButtons 으로 구성되어 있습니다.
        
        // verticalStackForContents로 따로 분리한 이유는 이 둘을 묶어 배경에 roundedRectangle이 있고 여기에 padding(inset)이 있는 형식으로 만들기 위함이었습니다. 로컬에서 초안처럼 생각나는대로 짜둔 구조라서 더 나은 구조가 있다면 변경하시면 됩니다.
        
        let horizontalStackForButtons = UIStackView()
        horizontalStackForButtons.axis = .horizontal
        horizontalStackForButtons.spacing = 17.0
        
        horizontalStackForButtons.addArrangedSubview(createdLabel)
        horizontalStackForButtons.addArrangedSubview(likesLabel)
        horizontalStackForButtons.addArrangedSubview(addChildCommentLabel)
        
        
        let verticalStackForContents = UIStackView()
        verticalStackForContents.axis = .vertical
        verticalStackForContents.spacing = 2.0
        
        verticalStackForContents.backgroundColor = FacebookColor.mildGray.color()
        verticalStackForContents.layer.cornerRadius = 20.0
        verticalStackForContents.isLayoutMarginsRelativeArrangement = true
        verticalStackForContents.layoutMargins = UIEdgeInsets(top: 8.0, left: 14.0, bottom: 8.0, right: 14.0)
        
        
        
        verticalStackForContents.addArrangedSubview(authorLabel)
        verticalStackForContents.addArrangedSubview(contentLabel)
        contentView.addSubview(verticalStackForContents)
        verticalStackForContents.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(profileImage)
        contentView.addSubview(horizontalStackForButtons)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackForButtons.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            profileImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 40.0),
            profileImage.heightAnchor.constraint(equalToConstant: 40.0),
            
            verticalStackForContents.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            verticalStackForContents.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 2.0),
            verticalStackForContents.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            horizontalStackForButtons.topAnchor.constraint(equalTo: verticalStackForContents.bottomAnchor, constant: 6.0),
            horizontalStackForButtons.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16.0),
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
