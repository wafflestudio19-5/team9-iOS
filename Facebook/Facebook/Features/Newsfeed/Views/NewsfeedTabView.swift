//
//  NewsfeedTabView.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit
import SnapKit

class NewsfeedTabView: UIView {
    
    let newsfeedTableView = ResponsiveTableView()
    let refreshControl = UIRefreshControl()
    let mainTableHeaderView = MainHeaderView()
    
    let logoView = UIView()
    
    let logoImage = UIImageView(image: UIImage(named: "WafflebookLogo"))
    
    lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Wafflebook"
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = UIColor(red: 248.0 / 255.0, green: 184.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutForView()
        setStyleForLogoImage()
        configureLogoView()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForView() {
        self.addSubview(newsfeedTableView)
        newsfeedTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func setStyleForLogoImage() {
        logoImage.contentMode = .scaleAspectFill
        logoImage.layer.cornerCurve = .continuous
        logoImage.layer.cornerRadius = 5.0
        logoImage.clipsToBounds = true
    }
    
    private func configureLogoView() {
        logoView.addSubview(logoImage)
        logoView.addSubview(logoLabel)
        
        logoImage.snp.makeConstraints { make in
            make.centerY.equalTo(logoView)
            make.width.height.equalTo(24.0)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoView)
            make.left.equalTo(logoImage.snp.right).offset(6)
        }
    }
    
    private func configureTableView() {
        newsfeedTableView.tableHeaderView = mainTableHeaderView
        mainTableHeaderView.widthAnchor.constraint(equalTo: newsfeedTableView.widthAnchor).isActive = true
        
        newsfeedTableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        newsfeedTableView.allowsSelection = false
        newsfeedTableView.refreshControl = refreshControl
        newsfeedTableView.separatorStyle = .none
        newsfeedTableView.showsVerticalScrollIndicator = false
    }
}
