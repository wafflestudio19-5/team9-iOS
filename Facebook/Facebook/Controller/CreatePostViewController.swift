//
//  CreatePostViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/15.
//

import UIKit
import RxSwift
import RxGesture

class CreatePostViewController<View: CreatePostView>: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = View()
    }
    
    var creatPostView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "게시글 만들기"
        setNavigationBarItems()
        bindNavigationBarItems()
    }

    func setNavigationBarItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(popToPrevious)
        )
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: creatPostView.postButton)
    }
    
    @objc private func popToPrevious() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func bindNavigationBarItems() {
        creatPostView.postButton.rx.tap.bind { _ in
            print("postButton tapped")
        }.disposed(by: disposeBag)
        
        //contentTextField가 비어있는 가에 대한 Bool형 event방출
        let hasEnteredContent = creatPostView.contentTextfield.rx.text.orEmpty.map { !$0.isEmpty }
        
        //contentTextField의 내용 유뮤에 따라 버튼 활성화
        hasEnteredContent.bind(to: self.creatPostView.postButton.rx.isEnabled).disposed(by: disposeBag)
        
        //contentTextField의 내용 유뮤에 따라 버튼 색상 변화
        hasEnteredContent
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] result in
                        guard let self = self else { return }
                        self.creatPostView.postButton.titleLabel?.textColor = {
                            return result ? UIColor.white : UIColor.lightGray
                        }()
                        self.creatPostView.postButton.backgroundColor = {
                            return result ? UIColor.systemBlue : UIColor.systemGray4
                        }()
                    }).disposed(by: disposeBag)
    }
}

