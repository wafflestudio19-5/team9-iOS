//
//  ActivateAccountView.swift
//  Facebook
//
//  Created by 최유림 on 2022/01/27.
//

import UIKit
import SnapKit

class ActivateAccountView: UIView {
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 13.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "EmailIllust"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var verificationButton = RectangularSlimButton(title: "인증 완료", titleColor: .white, backgroundColor: .tintColors.blue)
    lazy var logoutButton = RectangularSlimButton(title: "로그아웃", titleColor: .black, backgroundColor: .grayscales.button, highlightColor: .systemGray3)
    lazy var deleteAccountButton = RectangularSlimButton(title: "회원 탈퇴", titleColor: .red, backgroundColor: .white, highlightColor: .systemGray6)
    
    lazy var alertSpinner = AlertWithSpinner(message: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLabelText(with email: String) {
        contentLabel.attributedText = makeBold(originalText: "\(email) 주소로 계정을 활성화할 수 있는 이메일을 보내드렸습니다. 이메일에 포함된 링크를 클릭해주세요.", range: email)
        subContentLabel.text = "이메일이 도착하지 않았나요?\n\n이메일이 전송되는 데 약 1분의 시간이 소요됩니다.\n이후에도 메일을 받지 못하셨다면 스팸메일함이나 스마트메일함 등을 확인해주시기 바랍니다."
    }
    
    func activateAlertSpinner(workType: AuthManager.WorkType, at viewController: UIViewController) {
        alertSpinner.start(viewController: viewController, message: workType.getMessage())
    }
    
    private func makeBold(originalText: String, range: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: originalText)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: (originalText as NSString).range(of: "\(range)"))
        
        return attributedString
    }
    
    private func setLayoutForView() {
        self.addSubview(backgroundImage)
        self.addSubview(contentLabel)
        self.addSubview(subContentLabel)
        self.addSubview(verificationButton)
        self.addSubview(logoutButton)
        self.addSubview(deleteAccountButton)
        
        backgroundImage.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(52)
            make.width.height.equalTo(60)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImage.snp.bottom).offset(24)
            make.left.right.equalTo(self.safeAreaLayoutGuide).inset(48)
        }
        
        subContentLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(36)
            make.left.right.equalTo(self.safeAreaLayoutGuide).inset(52)
        }
        
        verificationButton.snp.makeConstraints { make in
            make.top.equalTo(subContentLabel.snp.bottom).offset(36)
            make.left.right.equalTo(self.safeAreaLayoutGuide).inset(18)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(verificationButton.snp.bottom).offset(10)
            make.left.right.equalTo(self.safeAreaLayoutGuide).inset(18)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(10)
            make.left.right.equalTo(self.safeAreaLayoutGuide).inset(18)
        }
    }
}
