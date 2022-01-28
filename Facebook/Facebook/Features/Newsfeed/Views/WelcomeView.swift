//
//  WelcomeView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/28.
//

import UIKit

class WelcomeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        self.addSubview(handView)
        self.addSubview(mainTitle)
        self.addSubview(subTitle)
        
        handView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.centerX.equalToSuperview()
            make.top.equalTo(170)
        }
        
        mainTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(handView.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        subTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTitle.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    func startAnimating() {
        let numberOfFrames: Double = 4
        let frameDuration = 1 / numberOfFrames
        let angle = CGFloat.pi / 8
        handView.setAnchorPoint(CGPoint(x: 0.7, y: 0.7))
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [],
          animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: frameDuration) {
                self.handView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration,
                               relativeDuration: frameDuration) {
                self.handView.transform = CGAffineTransform(rotationAngle: +angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration * 2,
                               relativeDuration: frameDuration) {
                self.handView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            UIView.addKeyframe(withRelativeStartTime: frameDuration * 3,
                               relativeDuration: frameDuration) {
                self.handView.transform = CGAffineTransform(rotationAngle: +angle)
            }
          },
          completion: nil
        )

    }
    
    let handView: UILabel = {
        let label = UILabel()
        label.text = "👋"
        label.font = .systemFont(ofSize: 72)
        return label
    }()
    
    let mainTitle: UILabel = {
        let label = UILabel()
        label.textColor = .grayscales.label
        label.text = "와플북에 오신 것을 환영합니다."
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.textColor = .grayscales.label
        label.textAlignment = .center
        label.text = "새로운 글을 등록하거나, \n우측 상단 검색 버튼을 눌러 친구들을 찾아보세요."
        label.numberOfLines = 0
        return label
    }()

}
