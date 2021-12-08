//
//  EnterBirthdateViewController.swift
//  Facebook
//
//  Created by peng on 2021/12/06.
//

import RxSwift
import RxGesture

class EnterBirthdateViewController<View: EnterBirthdateView>: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let dateFormatter = DateFormatter()
    
    override func loadView() {
        view = View()
    }
    
    private var enterBirthdateView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Facebook 가입하기"
        self.navigationItem.backButtonTitle = ""
        
        configureDateFormatter()
        bindView()
    }

    private func bindView() {
        
        // "선택" 버튼을 누를 경우에 DatePicker의 선택값을 textField의 text로 지정
        // 그 외 view를 터치할 경우에는 입력 상태만 false로 변경하고, 값이 반영되지는 않음
        enterBirthdateView.selectButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let selectedDate = self.enterBirthdateView.birthDatePicker.date
            self.enterBirthdateView.birthDateTextField.text = self.dateFormatter.string(from: selectedDate)
            self.enterBirthdateView.birthDateTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        enterBirthdateView.nextButton.rx.tap.bind {
            print("nextButton tapped")
            // navigate to enterPhoneNumberView
        }.disposed(by: disposeBag)
        
        view.rx.tapGesture(configuration: { _, delegate in
            delegate.touchReceptionPolicy = .custom { _, shouldReceive in
                return !(shouldReceive.view is UIControl)
            }
        }).bind { [weak self] _ in
            guard let self = self else { return }
            if self.enterBirthdateView.birthDateTextField.isEditing {
                self.enterBirthdateView.birthDateTextField.endEditing(true)
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
