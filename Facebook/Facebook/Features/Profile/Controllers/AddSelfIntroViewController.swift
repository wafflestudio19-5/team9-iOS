//
//  AddSelfIntroViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/30.
//

import UIKit
import RxSwift
import RxCocoa

class AddSelfIntroViewController<View: AddSelfIntroView>: UIViewController {

    override func loadView() {
        view = View()
    }
    
    var addSelfIntroView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    let disposeBag = DisposeBag()
    
    var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addSelfIntroView.inputTextView.becomeFirstResponder()
        setNavigationBarItems()
        loadData()
        bindView()
    }
    
    func setNavigationBarItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소", style: .plain, target: self, action: #selector(popToPrevious))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addSelfIntroView.saveButton)
    }
    
    @objc private func popToPrevious() {
           navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func loadData() {
        NetworkService.get(endpoint: .profile(id: 41), as: UserProfile.self)
            .subscribe { [weak self] event in
                guard let self = self else { return }
                
                if event.isCompleted {
                    return
                }
                
                guard let response = event.element?.1 else {
                    print("데이터 로드 중 오류 발생")
                    print(event)
                    return
                }
                
                self.userProfile = response
                self.setTextView()
        }.disposed(by: disposeBag)
    }
    
    func setTextView() {
        guard let userProfile = userProfile else { return }
        
        addSelfIntroView.inputTextView.text = (userProfile.self_intro != nil && userProfile.self_intro != "") ? userProfile.self_intro : ""
    }
    
    func bindView() {
        addSelfIntroView.saveButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                let updateData = ["self_intro": self.addSelfIntroView.inputTextView.text]
                
                NetworkService
                    .update(endpoint: .profile(id: 41, updateData: updateData))
                    .subscribe{ [weak self] _ in
                        self?.loadData()
                    }.disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
        
        //textView의 입력한 text길이 표시 및 제한
        addSelfIntroView.inputTextView.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            self?.addSelfIntroView.numberOfTextLabel.text = "\(text.count)/101"
            
            self?.addSelfIntroView.inputTextView.text = String(text.prefix(101))
        }).disposed(by: disposeBag)
        
        let hasEnteredSelfIntro = addSelfIntroView.inputTextView.rx.text
            .orEmpty
            .map{ !$0.isEmpty }
            
        hasEnteredSelfIntro.bind(to: self.addSelfIntroView.saveButton.rx.isEnabled).disposed(by: disposeBag)
        
        hasEnteredSelfIntro
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }

                if result {
                    self.addSelfIntroView.saveButton.titleLabel?.textColor = .black
                } else {
                    self.addSelfIntroView.saveButton.titleLabel?.textColor = .gray
                }
            }).disposed(by: disposeBag)
        
    }

}
