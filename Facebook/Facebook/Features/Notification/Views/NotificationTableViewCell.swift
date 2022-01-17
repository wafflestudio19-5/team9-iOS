//
//  NotificationTableViewCell.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/17.
//

import UIKit
import RxSwift
import SwiftUI

class NotificationTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "NotificationTableViewCell"
    
    private var disposeBag = DisposeBag()

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.numberOfLines = 3
        label.lineBreakMode = .byCharWrapping
        label.lineBreakStrategy = .pushOut
        return label
    }()
    
    lazy var timeStampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .gray
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
    
    lazy var detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: NotificationTableViewCell.reuseIdentifier)
        contentView.tintColor = .black
        configure()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure() {
        contentLabel.text = "IQUNIX에서 새로운 동영상을 게시했습니다: 'L80 Xmas Edition Wireless Mechanical Keyboar..."
        timeStampLabel.text = "17시간"
        
        profileImage.setImage(from: nil)
    }
    
    private func setLayoutForView() {
        contentView.addSubview(profileImage)
        verticalStackForContents.addArrangedSubview(contentLabel)
        verticalStackForContents.addArrangedSubview(timeStampLabel)
        contentView.addSubview(verticalStackForContents)
        contentView.addSubview(detailButton)
        
        profileImage.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(17)
            make.left.equalTo(contentView.snp.left).offset(16)
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
        let view = NotificationTableViewCell().contentView
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
