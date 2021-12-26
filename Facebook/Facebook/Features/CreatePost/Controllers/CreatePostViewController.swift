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
        self.title = "게시물 만들기"
        setNavigationBarStyle()
        setNavigationBarItems()
        bindNavigationBarItems()
    }
    
    func setNavigationBarStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .lightGray.withAlphaComponent(0.1)
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    func setNavigationBarItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(popToPrevious)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: creatPostView.postButton)
    }
    
    @objc private func popToPrevious() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    func bindNavigationBarItems() {
        creatPostView.postButton.rx.tap.bind { _ in
            NetworkService.post(endpoint: .newsfeed(content: self.creatPostView.contentTextfield.text ?? ""), as: Post.self)
                .subscribe(onNext: { [weak self] element in
                    guard let self = self else { return }
                    guard let rootTabBarController = self.presentingViewController as? RootTabBarController,
                          let newsfeedVC = rootTabBarController.newsfeedNavController.viewControllers.first as? NewsfeedTabViewController
                    else { return }
                    newsfeedVC.viewModel.refresh()
                    self.dismiss(animated: true, completion: nil)
                })
                .disposed(by: self.disposeBag)
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
                
                if result {
                    self.creatPostView.enablePostButton()
                } else {
                    self.creatPostView.disablePostButton()
                }
            })
            .disposed(by: disposeBag)
    }
}

