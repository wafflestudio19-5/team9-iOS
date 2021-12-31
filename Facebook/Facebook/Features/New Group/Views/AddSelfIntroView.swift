//
//  AddSelfIntroView.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/30.
//

import UIKit
import RxSwift
import RxCocoa

class AddSelfIntroView: UIView {

    let disposeBag = DisposeBag()
    
    let headerView = UIView()
    let nameLabel = UILabel()
    let privacyBountLabel = UILabel()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let inputTextView = UITextView()
    let numberOfTextLabel = UILabel()
    
    let saveButton: UIButton = {
            let button = UIButton()
            button.setTitle("저장", for: .normal)
            button.setTitleColor(.gray, for: .normal)
            return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setStyleForView()
        setLayoutForView()
        setTextViewPlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView() {
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        privacyBountLabel.font = UIFont.systemFont(ofSize: 15)
        privacyBountLabel.textColor = .gray
        
        nameLabel.text = "name"
        privacyBountLabel.text = "전체 공개"
        
        inputTextView.text =
            """
            짧은 소개를 추가하여 회원님에 대해 더 많이 알릴 수 있습니다.
            좋아하는 문구나 회원님을 행복하게 만드는 것을 입력해보세요.
            """
        inputTextView.textColor = .gray
        inputTextView.font = UIFont.systemFont(ofSize: 15)
    }
    
    private func setLayoutForView() {
        headerView.addSubview(nameLabel)
        headerView.addSubview(privacyBountLabel)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        privacyBountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 45),
            nameLabel.heightAnchor.constraint(equalToConstant: 15),
            privacyBountLabel.heightAnchor.constraint(equalToConstant: 15),
            nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            privacyBountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            privacyBountLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5),
            privacyBountLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10)
        ])
        
        self.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        self.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        self.addSubview(inputTextView)
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputTextView.heightAnchor.constraint(equalToConstant: 40),
            inputTextView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            inputTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            inputTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        self.addSubview(numberOfTextLabel)
        numberOfTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberOfTextLabel.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 10),
            numberOfTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }
    
    private func setTextViewPlaceholder() {
        inputTextView.rx.didBeginEditing.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if self.inputTextView.text ==
                """
                짧은 소개를 추가하여 회원님에 대해 더 많이 알릴 수 있습니다.
                좋아하는 문구나 회원님을 행복하게 만드는 것을 입력해보세요.
                """ {
                self.inputTextView.text = nil
                self.inputTextView.textColor = .black
            }
        }).disposed(by: disposeBag)
        
        inputTextView.rx.didEndEditing.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if self.inputTextView.text == nil || self.inputTextView.text == "" {
                self.inputTextView.text =
                """
                짧은 소개를 추가하여 회원님에 대해 더 많이 알릴 수 있습니다.
                좋아하는 문구나 회원님을 행복하게 만드는 것을 입력해보세요.
                """
                self.inputTextView.textColor = .gray
            }
        }).disposed(by: disposeBag)
    }
}
