//
//  NotificationCell.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/17.
//

import UIKit
import RxSwift
import SwiftUI

class NotificationCell: UITableViewCell {
    
    static let reuseIdentifier = "NotificationCell"
    
    var disposeBag = DisposeBag()

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.numberOfLines = 3
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    lazy var subcontentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var timeStampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var profileImage = ProfileImageView()
    
    lazy var verticalStackForContents: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.alignment = .leading
        return stackView
    }()
    
    lazy var horizontalStackForSubcontents: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3.0
        stackView.alignment = .leading
        return stackView
    }()
    
    lazy var detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.tintColor = .black
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func configure(with notification: Notification) {
        contentLabel.attributedText = addAttributeForMessage(user: notification.sender_preview.username, message: notification.content.message(user: notification.sender_preview.username))
        timeStampLabel.text = notification.posted_at
        subcontentLabel.text = { () -> String in
            if let comment = notification.comment_preview?.content {
                return "· \"" + comment + "\""
            } else { return "" }
        }()
        
        if let urlString = notification.sender_preview.profile_image {
            profileImage.setImage(from: URL(string: urlString))
        } else {
            profileImage.setImage(from: nil)
        }
    }
    
    private func addAttributeForMessage(user: String, message: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: message)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: (message as NSString).range(of: user))
        return attributedString
    }
    
    private func setLayoutForView() {
        contentView.addSubview(profileImage)
        contentView.addSubview(verticalStackForContents)
        horizontalStackForSubcontents.addArrangedSubview(timeStampLabel)
        horizontalStackForSubcontents.addArrangedSubview(subcontentLabel)
        verticalStackForContents.addArrangedSubview(contentLabel)
        verticalStackForContents.addArrangedSubview(horizontalStackForSubcontents)
        contentView.addSubview(detailButton)
        
        profileImage.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.left.equalTo(contentView.snp.left).offset(15)
            make.height.width.equalTo(68)
        }
        
        verticalStackForContents.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(10)
            make.centerY.equalTo(contentView)
            make.right.equalTo(detailButton.snp.left).offset(-16).priority(999)
        }
        
        detailButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-16).priority(999)
        }
    }
}



struct NotificationCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = NotificationCell().contentView
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct NotificationCellPreview: PreviewProvider {
    static var previews: some View {
        VStack{
            Spacer()
            NotificationCellRepresentable()
            Spacer()
        }.preferredColorScheme(.light).previewDevice("iPhone 12 Pro").background(.white)
    }
}
