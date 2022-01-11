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
        setTextView()
        bind()
    }
    
    func setNavigationBarItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소", style: .plain, target: self, action: #selector(popToPrevious))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addSelfIntroView.saveButton)
    }
    
    @objc private func popToPrevious() {
           navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func setTextView() {
        addSelfIntroView.nameLabel.text = StateManager.of.user.profile.username
        addSelfIntroView.inputTextView.text = (StateManager.of.user.profile.self_intro != "")
                                                ? StateManager.of.user.profile.self_intro : ""
    }
    
    func bind() {
        addSelfIntroView.saveButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                let updateData = ["self_intro": self.addSelfIntroView.inputTextView.text]
                
                NetworkService
                    .update(endpoint: .profile(id: UserDefaultsManager.cachedUser?.id ?? 0, updateData: updateData))
                    .subscribe { event in
                        let request = event.element
                    
                        request?.responseDecodable(of: UserProfile.self) { dataResponse in
                            guard let userProfile = dataResponse.value else { return }
                            StateManager.of.user.profileDataSource.accept(userProfile)
                        }
                    }.disposed(by: self.disposeBag)
                
                self.navigationController?.dismiss(animated: true, completion: nil)
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
