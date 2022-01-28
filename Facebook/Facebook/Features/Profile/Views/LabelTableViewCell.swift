//
//  SelfIntroTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/22.
//

import UIKit
import RxSwift
import RxCocoa

class LabelTableViewCell: UITableViewCell {

    static let reuseIdentifier = "LabelTableViewCell"
    
    var disposeBag = DisposeBag()
    
    enum Style {
        case style1
        case style2
    }
    
    var cellStyle: Style = .style1
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
          disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initialSetup(cellStyle: Style) {
        self.cellStyle = cellStyle
        setStyle()
        setLayout()
    }
    
    func configureCell(labelText: String) {
        label.text = labelText
    }
    
    private func setStyle() {
        switch self.cellStyle {
        case .style1:
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = .gray
            label.textAlignment = .center
        case .style2:
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .gray
            label.textAlignment = .left
        }
    }
    
    private func setLayout() {
        switch self.cellStyle {
        case .style1:
            self.contentView.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.centerX.equalToSuperview()
                make.edges.equalToSuperview().inset(10)
            }
        case .style2:
            self.contentView.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.top.bottom.left.equalToSuperview().inset(15)
            }
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
}
