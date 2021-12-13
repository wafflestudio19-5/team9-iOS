//
//  EnterBirthdateViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/06.
//

import RxSwift
import RxGesture

class EnterBirthdateViewController: BaseSignUpViewController<EnterBirthdateView> {
    
    private let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDateFormatter()
        bindView()
    }

    private func bindView() {
        
        // "선택" 버튼을 누를 경우에 DatePicker의 선택값을 textField의 text로 지정
        // 그 외 view를 터치할 경우에는 입력 상태만 false로 변경하고, 값이 반영되지는 않음
        customView.selectButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let selectedDate = self.customView.birthDatePicker.date
            self.customView.birthDateTextField.text = self.dateFormatter.string(from: selectedDate)
            self.customView.birthDateTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        customView.nextButton.rx.tap.bind {
            self.push(viewController: EnterEmailViewController())
        }.disposed(by: disposeBag)
        
        view.rx.tapGesture(configuration: { _, delegate in
            delegate.touchReceptionPolicy = .custom { _, shouldReceive in
                return !(shouldReceive.view is UIControl)
            }
        }).bind { [weak self] _ in
            guard let self = self else { return }
            if self.customView.birthDateTextField.isEditing {
                self.customView.birthDateTextField.endEditing(true)
            }
        }.disposed(by: disposeBag)
    }
}

extension EnterBirthdateViewController {
    private func configureDateFormatter() {
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "ko-KR")
    }
}
