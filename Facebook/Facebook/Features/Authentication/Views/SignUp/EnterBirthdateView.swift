//
//  EnterBirthdateView.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/06.
//

import UIKit

class EnterBirthdateView: BaseSignUpView {

    let birthDatePicker = UIDatePicker()
    
    private let birthDatePickerToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
    private let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let selectButton = UIBarButtonItem(title: "선택", style: .plain, target: nil, action: nil)
    
    let birthDateTextField = FacebookTextField(placeholderText: "생년월일")
    
    let ageLabel = UILabel()

    let nextButton = RectangularSlimButton(title: "다음", titleColor: .white, backgroundColor: FacebookColor.blue.color())
    
    init() {
        super.init(title: "생일을 알려주세요", instruction: "생년월일을 선택하세요. 나중에 언제든지 비공개로 변경할 수 있습니다.")
        
        setStyleForView()
        setLimitForBirthdatePicker()
        addButtonToBirthdatePicker()
        setLayoutForView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBirthDateText(as birthDate: String) {
        birthDateTextField.text = birthDate
    }
    
    func setAlertLabelText(as text: String) {
        if !text.isEmpty { showAlertLabel(as: text) }
        else { hideAlertLabel() }
    }
    
    private func setStyleForView() {
        birthDatePicker.datePickerMode = .date
        birthDatePicker.preferredDatePickerStyle = .wheels
        birthDatePicker.locale = Locale(identifier: "ko-KR")
        birthDatePicker.timeZone = .autoupdatingCurrent
        birthDatePicker.backgroundColor = .white

        birthDateTextField.inputView = birthDatePicker
        birthDateTextField.textColor = FacebookColor.blue.color()
        
        ageLabel.font = .systemFont(ofSize: 14.0)
        ageLabel.textAlignment = .center
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

        self.addCustomView(view: birthDateTextField)
        self.addSubview(ageLabel)
        self.addSubview(nextButton)
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ageLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            ageLabel.topAnchor.constraint(equalTo: verticalStackWithAlertLabel.bottomAnchor, constant: 14.0),
            ageLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),

            nextButton.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 16.0),
            nextButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 72.0),
            nextButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -72.0),
        ])
    }
}
