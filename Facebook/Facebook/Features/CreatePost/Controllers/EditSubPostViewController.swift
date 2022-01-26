//
//  EditSubPostViewController.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/26.
//

import UIKit
import RxSwift

class EditSubPostViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "편집"
        view.backgroundColor = .white
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = doneButton
        doneButton.rx.tap.bind { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
}
