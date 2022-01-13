//
//  FriendCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/13.
//

import UIKit
import RxSwift

class FriendCell: UITableViewCell {
    
    var refreshingBag = DisposeBag().
    var permanentBag = DisposeBag()
    static let reuseIdentifier = "FriendCell"

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
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        
    }

}
