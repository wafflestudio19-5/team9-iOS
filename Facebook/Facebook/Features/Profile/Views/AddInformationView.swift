//
//  AddInformationView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/23.
//

import UIKit

class AddInformationView: UIView {

    let addInformationTableView = UITableView(frame: .zero, style: .grouped)
    
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(addInformationTableView)
        addInformationTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        footerView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        self.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).priority(999)
        }
    }
    
    private func configureTableView() {
        addInformationTableView.separatorStyle = .singleLine
        addInformationTableView.backgroundColor = .systemGray5
        addInformationTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        addInformationTableView.register(SimpleInformationTableViewCell.self, forCellReuseIdentifier: SimpleInformationTableViewCell.reuseIdentifier)
        addInformationTableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.reuseIdentifier)
        addInformationTableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: TextViewTableViewCell.reuseIdentifier)
        addInformationTableView.register(DateSelectTableViewCell.self, forCellReuseIdentifier: DateSelectTableViewCell.reuseIdentifier)
        addInformationTableView.allowsSelection = false
    }
}
