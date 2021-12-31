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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addSelfIntroView.inputTextView.becomeFirstResponder()
        setNavigationBarItems()
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
    
    func bindView() {
        addSelfIntroView.saveButton.rx.tap
            .bind{ [weak self] _ in
            
            }.disposed(by: disposeBag)
        
        let hasEnteredSelfIntro = addSelfIntroView.inputTextView.rx.text
            .orEmpty
            .map{ !$0.isEmpty }
            
        hasEnteredSelfIntro.bind(to: self.addSelfIntroView.saveButton.rx.isEnabled).disposed(by: disposeBag)
        
        hasEnteredSelfIntro
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                            
                if result {
                    self.addSelfIntroView.saveButton.tintColor = .black
                } else {
                    self.addSelfIntroView.saveButton.tintColor = .gray
                }
            }).disposed(by: disposeBag)
        
    }

}
