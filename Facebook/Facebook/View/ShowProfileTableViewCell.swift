//
//  ShowProfileTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit
import RxSwift
import RxGesture
import RxCocoa


protocol ShowProfileTableViewCellDelegate: AnyObject {
    func goDetailProfileView()
}

class ShowProfileTableViewCell: UITableViewCell {

    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bindCellTapGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: ShowProfileTableViewCellDelegate?
    
    private func bindCellTapGesture() {
        self.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            self.delegate?.goDetailProfileView()
        }).disposed(by: disposeBag)
    }
}
