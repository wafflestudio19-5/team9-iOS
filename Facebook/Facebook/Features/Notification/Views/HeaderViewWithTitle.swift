//
//  HeaderViewWithTitle.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/25.
//

import UIKit
import SnapKit

class HeaderViewWithTitle: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "HeaderViewWithTitle"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(as title: String) {
        self.titleLabel.text = title
    }
    
    private func setLayoutForView() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(16)
        }
    }
}
