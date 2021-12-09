//
//  SelectGenderView.swift
//  Facebook
//
//  Created by peng on 2021/12/09.
//

import UIKit

class SelectGenderView: UIView {
    
    let genderTableView = ContentSizeFitTableView()

    let baseSignUpView = BaseSignUpView(title: "성별을 알려주세요", instruction: "나중에 프로필에서 회원님의 성별을 볼 수 있는 사람을 변경할 수 있습니다.")
    
    let nextButton = RectangularSlimButton(title: "다음", titleColor: .white, backgroundColor: FacebookColor.blue.color())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStyleForView() {
        genderTableView.separatorStyle = .none
        genderTableView.isScrollEnabled = false
    }
    
    private func setLayoutForView() {

        self.addSubview(baseSignUpView)
        self.addSubview(genderTableView)
        self.addSubview(nextButton)
        
        baseSignUpView.translatesAutoresizingMaskIntoConstraints = false
        genderTableView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            baseSignUpView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            baseSignUpView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            baseSignUpView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            genderTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            genderTableView.topAnchor.constraint(equalTo: baseSignUpView.bottomAnchor, constant: 24.0),
            genderTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),
            
            nextButton.topAnchor.constraint(equalTo: genderTableView.bottomAnchor, constant: 16.0),
            nextButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 72.0),
            nextButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -72.0),
        ])
    }
}
