//
//  FriendCollectionTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/15.
//

import UIKit
import RxSwift
import RxCocoa

class FriendCollectionTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FriendCollectionTableViewCell"
    
    var refreshingBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
        refreshingBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }
    
    func configureCell(with friendsData: [User], friendInfo: String) {
        Observable.just(friendsData)
            .observe(on: MainScheduler.instance)
            .bind(to: friendGridCollectionView.rx.items(cellIdentifier: FriendGridCell.reuseIdentifier, cellType: FriendGridCell.self)) { row, data, cell in
                cell.configureCell(with: data, isMe: (friendInfo == "self") ? true : false)
            }
            .disposed(by: refreshingBag)

        layoutIfNeeded()
    }
    
    private func setLayout() {
        contentView.addSubview(friendGridCollectionView)
        friendGridCollectionView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(showFriendButton)
        showFriendButton.snp.remakeConstraints { make in
            make.height.equalTo(35)
            make.top.equalTo(friendGridCollectionView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    let friendGridCollectionView = FriendGridCollectionView()
    
    let showFriendButton: UIButton = {
        let button = UIButton()
        button.setTitle("모든 친구 보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 5
        
        return button
    }()
}
