//
//  DetailProfileTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/11/26.
//

import UIKit
import RxSwift
import RxGesture
import RxCocoa

protocol DetailProfileTableViewCellDelegate: AnyObject {
    func goEditDetailProfileView()
}

class DetailProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var informationImage: UIImageView!
    @IBOutlet weak var informationLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: DetailProfileTableViewCellDelegate?
    
    private func bindCellTapGesture() {
        self.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            self?.delegate?.goEditDetailProfileView()
        }).disposed(by: disposeBag)
    }
}
