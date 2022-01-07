//
//  KakaoLoginView.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/07.
//

import UIKit

class KakaoLoginView: UIView {

    let instructionLabel = UILabel()
    let kakaoLoginButton = RectangularSlimButton(title: "카카오 계정 연동하기", titleColor: .brown, backgroundColor: .systemYellow)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setTextForLabel()
        setStyleForView()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTextForLabel() {
        instructionLabel.text = "카카오 계정 연동을 통해 로그인 화면에서 간편 로그인 기능을 사용할 수 있습니다.\n카카오 계정 연동을 원하신다면, 아래 버튼을 눌러 연동 과정을 진행하시기 바랍니다. \"건너뛰기\"를 누르시면 추후 마이페이지 등을 통해서도 카카오 계정을 연동하실 수 있습니다."
    }
    
    private func setStyleForView() {
        instructionLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        
        kakaoLoginButton.contentMode = .scaleAspectFill
    }

    private func setLayoutForView() {
        
        self.addSubview(instructionLabel)
        self.addSubview(kakaoLoginButton)
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50.0),
            instructionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 36.0),
            instructionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -36.0),
            
            kakaoLoginButton.heightAnchor.constraint(equalTo: kakaoLoginButton.widthAnchor, multiplier: 0.15),
            kakaoLoginButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            kakaoLoginButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            kakaoLoginButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30.0),
        ])
    }
}
