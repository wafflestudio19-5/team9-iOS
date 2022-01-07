//
//  KakaoLoginView.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/07.
//

import UIKit

class KakaoLoginView: UIView {

    let instructionLabel = UILabel()
    let skipButton = RectangularSlimButton(title: "건너뛰기", titleColor: .black, backgroundColor: .Grayscales.gray3)
    let kakaoLoginButton = UIImageView(image: UIImage(named: "KakaoLoginButton"))
    
    let backgroundImage = UIImageView(image: UIImage(named: "KakaoBackgroundIllust"))
    
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
        instructionLabel.text = "카카오 계정 연동을 통해 로그인 화면에서 간편 로그인 기능을 사용할 수 있습니다.\n\n아래 버튼을 눌러 연동 과정을 진행하시기 바랍니다."
    }
    
    private func setStyleForView() {
        instructionLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        
        kakaoLoginButton.contentMode = .scaleAspectFit
        
        backgroundImage.contentMode = .scaleAspectFit
    }

    private func setLayoutForView() {
        
        self.addSubview(instructionLabel)
        self.insertSubview(backgroundImage, at: 0)
        self.addSubview(skipButton)
        self.addSubview(kakaoLoginButton)
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 48.0),
            instructionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 36.0),
            instructionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -36.0),
            
            backgroundImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 40.0),
            backgroundImage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32.0),
            backgroundImage.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32.0),
            
            skipButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            skipButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            skipButton.bottomAnchor.constraint(equalTo: kakaoLoginButton.topAnchor, constant: -10.0),
            
            kakaoLoginButton.heightAnchor.constraint(equalTo: kakaoLoginButton.widthAnchor, multiplier: 0.15),
            kakaoLoginButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            kakaoLoginButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            kakaoLoginButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30.0),
        ])
    }
}
