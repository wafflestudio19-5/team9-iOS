//
//  CommentModalViewConroller.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/24.
//

import UIKit

class CommentModalViewConroller: PostDetailViewController {
    
    override var useSafeAreaLayoutGuide: Bool { false }
    
    override func loadView() {
        view = CommentModalView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 필요 없는 뷰 삭제
        postHeader.postContentView.removeFromSuperview()
        postHeader.buttonStackView.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.asFirstResponder && !keyboardTextView.isFirstResponder {
            keyboardTextView.becomeFirstResponder()
            self.asFirstResponder = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func setNavBarItems() {
        title = "댓글"
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = doneButton
        doneButton.rx.tap.bind { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }

}
