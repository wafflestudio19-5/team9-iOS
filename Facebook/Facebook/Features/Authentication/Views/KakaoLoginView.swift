//
//  KakaoLoginView.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/07.
//

import UIKit
import SnapKit

class KakaoLoginView: UIView {

    let instructionLabel = UILabel()
    let skipButton = RectangularSlimButton(title: "건너뛰기", titleColor: .black, backgroundColor: .grayscales.button, highlightColor: .systemGray3)
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
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(48)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(36)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-36).priority(999)
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.centerY.equalTo(self).offset(40)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(32)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-32).priority(999)
        }
        
        skipButton.snp.makeConstraints { make in
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-10)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-20).priority(999)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-20).priority(999)
            make.height.equalTo(kakaoLoginButton.snp.width).multipliedBy(0.15)
        }
    }
}
