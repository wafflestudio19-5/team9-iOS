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

    let postButton = UIButton()
    
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
        setStyleForNavigationBarItems()
        setNavigationBarItems()
        bindNavigationBarItems()
    }
    
    func setStyleForNavigationBarItems() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "xmark")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "xmark")
        
        postButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        postButton.setTitle("게시", for: .normal)
        postButton.setTitleColor(UIColor.lightGray, for: .normal)
        postButton.backgroundColor = .systemGray4
        postButton.layer.cornerRadius = 5
    }
    
    func setNavigationBarItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: postButton)
    }
    
    func bindNavigationBarItems() {
        postButton.rx.tap.bind { _ in
            print("postButton tapped")
        }.disposed(by: disposeBag)
        
        //contentTextField가 비어있는 가에 대한 Bool형 event방출
        let hasEnteredContent = creatPostView.contentTextfield.rx.text.orEmpty.map { !$0.isEmpty }
        
        //contentTextField의 내용 유뮤에 따라 버튼 활성화
        hasEnteredContent.bind(to: self.postButton.rx.isEnabled).disposed(by: disposeBag)
        
        //contentTextField의 내용 유뮤에 따라 버튼 색상 변화
        hasEnteredContent
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] result in
                        guard let self = self else { return }
                        self.postButton.titleLabel?.textColor = {
                            return result ? UIColor.white : UIColor.lightGray
                        }()
                        self.postButton.backgroundColor = {
                            return result ? UIColor.systemBlue : UIColor.systemGray4
                        }()
                    }).disposed(by: disposeBag)
    }
}

