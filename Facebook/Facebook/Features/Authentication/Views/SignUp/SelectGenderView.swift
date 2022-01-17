//
//  SelectGenderView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import UIKit

class SelectGenderView: BaseSignUpView {
    
    let genderTableView = ContentSizeFitTableView()
    
    let nextButton = RectangularSlimButton(title: "다음", titleColor: .white, backgroundColor: .tintColors.blue)
    
    init() {
        super.init(title: "성별을 알려주세요", instruction: "나중에 프로필에서 회원님의 성별을 볼 수 있는 사람을 변경할 수 있습니다.")
        
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAlertLabelText(as text: String) {
        if !text.isEmpty { showAlertLabel(as: text, setOnTop: true) }
        else { hideAlertLabel() }
    }

    private func setStyleForView() {
        genderTableView.separatorStyle = .none
        genderTableView.isScrollEnabled = false
    }
    
    private func setLayoutForView() {

        self.addCustomView(view: genderTableView)
        self.addSubview(nextButton)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: verticalStackWithAlertLabel.bottomAnchor, constant: 16.0),
            nextButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 72.0),
            nextButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -72.0),
        ])
    }
}
