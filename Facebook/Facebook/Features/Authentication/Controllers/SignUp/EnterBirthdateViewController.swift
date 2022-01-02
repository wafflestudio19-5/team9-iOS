//
//  EnterBirthdateViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/06.
//

import RxSwift
import RxGesture
import RxCocoa

class EnterBirthdateViewController: BaseSignUpViewController<EnterBirthdateView> {
    
    private enum BirthdateValidation {
        case valid
        case invalid
        
        // 페이스북 앱에서는 5세 이상이면 다음 페이지로 넘어갈 수 있습니다
        init(age: Int) {
            if age >= 5 { self = .valid }
            else { self = .invalid }
        }
        
        func message() -> String {
            switch self {
            case .valid: return ""
            case .invalid: return "잘못된 정보를 입력한 것 같습니다. 실제 생일을 입력해주세요."
            }
        }
    }
    
    private let koreanDateFormatter = DateFormatter()   // yyyy년 MM월 dd일
    private let hyphenDateFormatter = DateFormatter()   // yyyy-MM-dd
    
    private let birthDate = BehaviorRelay<Date>(value: Date())
    
    private var isValidBirthdate: BirthdateValidation?

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
            self.birthDate.accept(selectedDate)
            self.customView.birthDateTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        // 생년월일을 textField에 적용
        birthDate
            .asDriver()
            .skip(1)
            .map { self.koreanDateFormatter.string(from: $0) }
            .drive(customView.birthDateTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 생년월일로 나이 계산 후 ageLabel 적용
        birthDate
            .asDriver()
            .skip(1)
            .map { "\(self.calculateAge(from: $0))세" }
            .drive(customView.ageLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 생년월일에 대한 validation
        birthDate
            .map { self.calculateAge(from: $0) }
            .bind { [weak self] age in
                guard let self = self else { return }
                self.isValidBirthdate = BirthdateValidation.init(age: age)
            }.disposed(by: disposeBag)

        customView.nextButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                guard let isValidBirthdate = self.isValidBirthdate else { return }

                self.customView.setAlertLabelText(as: isValidBirthdate.message())
                
                if isValidBirthdate == .valid {
                    NewUser.shared.birth = self.hyphenDateFormatter.string(from: self.birthDate.value)
                    self.push(viewController: EnterEmailViewController())
                }
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
        koreanDateFormatter.dateStyle = .long
        koreanDateFormatter.locale = Locale(identifier: "ko-KR")
        
        hyphenDateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    private func calculateAge(from birthDate: Date) -> Int {
        let birthDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: birthDate)
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        guard case let (birthDateYear?, birthDateMonth?, birthDateDay?, currentDateYear?, currentDateMonth?, currentDateDay?) = (birthDateComponents.year, birthDateComponents.month, birthDateComponents.day, currentDateComponents.year, currentDateComponents.month, currentDateComponents.day) else {
            return 0
        }
        
        if birthDateMonth * 10 + birthDateDay <= currentDateMonth * 10 + currentDateDay {
            return currentDateYear - birthDateYear
        } else {
            return currentDateYear - birthDateYear - 1
        }
    }
}
