//
//  EnterBirthdateView.swift
//  Facebook
//
//  Created by peng on 2021/12/06.
//

import UIKit

class EnterBirthdateView: UIView {

    let birthDatePicker = UIDatePicker()
    
    let birthDatePickerToolbar = UIToolbar()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let selectButton = UIBarButtonItem(title: "선택", style: .plain, target: nil, action: nil)
    
    let birthDateTextField = FacebookTextField(placeholderText: "생년월일")
    
    let baseSignUpView = BaseSignUpView(title: "생일을 알려주세요", instruction: "생년월일을 선택하세요. 나중에 언제든지 비공개로 변경할 수 있습니다.")
    
    let nextButton = RectangularSlimButton(title: "다음", titleColor: .white, backgroundColor: FacebookColor.blue.color())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setStyleForView()
        setLimitForBirthdatePicker()
        addButtonToBirthdatePicker()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleForView() {
        birthDatePicker.datePickerMode = .date
        birthDatePicker.preferredDatePickerStyle = .wheels
        birthDatePicker.locale = Locale(identifier: "ko-KR")
        birthDatePicker.timeZone = .autoupdatingCurrent
        birthDatePicker.backgroundColor = .white

        birthDateTextField.inputView = birthDatePicker
        birthDateTextField.textColor = FacebookColor.blue.color()
    }
    
    private func addButtonToBirthdatePicker() {
        birthDatePickerToolbar.sizeToFit()
        birthDatePickerToolbar.backgroundColor = .white
        
        birthDatePickerToolbar.setItems([flexibleSpace, selectButton], animated: true)
        birthDateTextField.inputAccessoryView = birthDatePickerToolbar
    }
    
    // 페이스북에서는 생년월일을 1905년부터 설정 가능합니다
    private func setLimitForBirthdatePicker() {
        var minimumYear = DateComponents()
        minimumYear.year = 1905
       
        birthDatePicker.minimumDate = Calendar.autoupdatingCurrent.date(from: minimumYear)
        birthDatePicker.maximumDate = Date()
    }
    
    private func setLayoutForView() {

        self.addSubview(baseSignUpView)
        self.addSubview(birthDateTextField)
        self.addSubview(nextButton)
        
        baseSignUpView.translatesAutoresizingMaskIntoConstraints = false
        birthDateTextField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            baseSignUpView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            baseSignUpView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            baseSignUpView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            birthDateTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            birthDateTextField.topAnchor.constraint(equalTo: baseSignUpView.bottomAnchor, constant: 24.0),
            birthDateTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),

            nextButton.topAnchor.constraint(equalTo: birthDateTextField.bottomAnchor, constant: 16.0),
            nextButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 72.0),
            nextButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -72.0),
        ])
    }
}
