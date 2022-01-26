//
//  BottomSheetView.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/21.
//

import UIKit

class BottomSheetView: UIView {
    let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.0

        return view
    }()
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    let bottomSheetTableView = UITableView()
    
    var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bottomSheetTableView.backgroundColor = .white
        setLayoutForView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayoutForView() {
        self.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(contentView)
        bottomSheetViewTopConstraint = contentView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height)
        bottomSheetViewTopConstraint.isActive = true
        contentView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
        }
         
        contentView.addSubview(bottomSheetTableView)
        bottomSheetTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.bottom.left.right.equalToSuperview()
        }
        
        contentView.addSubview(dragIndicatorView)
        dragIndicatorView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(dragIndicatorView.layer.cornerRadius * 2)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
        }
    }
    
    func configureTableView() {
        bottomSheetTableView.separatorStyle = .none
        bottomSheetTableView.register(BottomSheetCell.self, forCellReuseIdentifier: BottomSheetCell.reuseIdentifier)
        bottomSheetTableView.isScrollEnabled = false
    }
}
