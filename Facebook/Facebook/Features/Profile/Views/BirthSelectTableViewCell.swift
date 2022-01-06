//
//  BirthSelectTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/02.
//

import UIKit
import RxSwift
import RxCocoa

class BirthSelectTableViewCell: UITableViewCell {

    static let reuseIdentifier = "BirthSelectTableViewCell"
    
    var disposeBag = DisposeBag()
    
    enum Style {
        case birthDay
        case birthYear
    }
    
    var cellStyle: Style = .birthDay
    
    let yearPickerView = UIPickerView()
    let monthPickerView = UIPickerView()
    let dayPickerView = UIPickerView()
    let yearPickerToolbar = UIToolbar()
    let monthPickerToolbar = UIToolbar()
    let dayPickerToolbar = UIToolbar()
    
    let doneButtonList = [UIBarButtonItem(title: "확인", style: .plain, target: nil, action: nil),
                          UIBarButtonItem(title: "확인", style: .plain, target: nil, action: nil),
                          UIBarButtonItem(title: "확인", style: .plain, target: nil, action: nil)]
    let flexibleSpaceList = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                             UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                             UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
    let cancelButtonList = [UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil),
                            UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil),
                            UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)]
    
    var yearDataBR: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: [])
    let monthDataBR: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"])
    var dayDataBR: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: [])
    
    lazy var selectedYear = ""
    lazy var selectedMonth = ""
    lazy var selectedDay = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
          disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialSetup(cellStyle: Style) {
        self.cellStyle = cellStyle
        setStyle()
        setLayout()
    }
    
    func configureCell(birthInfo: String) {
        switch self.cellStyle{
        case .birthDay:
            label.text = "생일"
            monthTextField.text = birthInfo.split(separator: "-")[1].trimmingCharacters(in: ["0"]) + "월"
            dayTextField.text = String(birthInfo.split(separator: "-")[2])
            selectedMonth = birthInfo.split(separator: "-")[1].trimmingCharacters(in: ["0"]) + "월"
            selectedDay = String(birthInfo.split(separator: "-")[2])
        case .birthYear:
            label.text = "태어난 연도"
            yearTextField.text = String(birthInfo.split(separator: "-")[0])
            selectedYear = String(birthInfo.split(separator: "-")[0])
        }
        
        setDataForPicker()
        bindPickerToolbar()
    }
    
    private func setStyle() {
        yearPickerToolbar.sizeToFit()
        monthPickerToolbar.sizeToFit()
        dayPickerToolbar.sizeToFit()
        
        yearPickerToolbar.setItems([cancelButtonList[0], flexibleSpaceList[0], doneButtonList[0]], animated: true)
        monthPickerToolbar.setItems([cancelButtonList[1], flexibleSpaceList[1], doneButtonList[1]], animated: true)
        dayPickerToolbar.setItems([cancelButtonList[2], flexibleSpaceList[2], doneButtonList[2]], animated: true)
        
        yearTextField.inputAccessoryView = yearPickerToolbar
        yearTextField.inputView = yearPickerView
        monthTextField.inputAccessoryView = monthPickerToolbar
        monthTextField.inputView = monthPickerView
        dayTextField.inputAccessoryView = dayPickerToolbar
        dayTextField.inputView = dayPickerView
    }
    
    private func setLayout() {
        self.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10)
        ])
        
        switch self.cellStyle {
        case .birthDay:
            self.contentView.addSubview(monthTextField)
            NSLayoutConstraint.activate([
                monthTextField.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                monthTextField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10)
            ])
            
            self.contentView.addSubview(dayTextField)
            NSLayoutConstraint.activate([
                dayTextField.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                dayTextField.leadingAnchor.constraint(equalTo: monthTextField.trailingAnchor, constant: 10)
            ])
        case .birthYear:
            self.contentView.addSubview(yearTextField)
            NSLayoutConstraint.activate([
                yearTextField.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                yearTextField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10)
            ])
        }
    }
    
    private func setDataForPicker() {
        switch self.cellStyle {
        case .birthDay:
            switch selectedMonth {
            case "1월","3월","5월","7월","8월","10월","12월":
                let dayArray = Array(1...31).map({ String($0) })
                dayDataBR.accept(dayArray)
            case "4월","6월","9월","11월":
                let dayArray = Array(1...30).map({ String($0) })
                dayDataBR.accept(dayArray)
            case "2월":
                let dayArray = Array(1...28).map({ String($0) })
                dayDataBR.accept(dayArray)
            default:
                dayDataBR.accept([])
            }
        case .birthYear:
            let now = Date()
            let calender = Calendar.current
            let currentYear = calender.component(.year, from: now)
            let yearArray = Array((currentYear-100)...currentYear).map({ String($0) })
            yearDataBR.accept(yearArray)
        }
    }
    
    private func bindPickerToolbar() {
        yearDataBR.bind(to: yearPickerView.rx.itemTitles) { (row, element) in
            return "\(element)"
        }.disposed(by: disposeBag)
        
        monthDataBR.bind(to: monthPickerView.rx.itemTitles) { (row, element) in
            return element
        }.disposed(by: disposeBag)
        
        dayDataBR.bind(to: dayPickerView.rx.itemTitles) { (row, element) in
            return "\(element)"
        }.disposed(by: disposeBag)
        
        yearTextField.rx.controlEvent(.editingDidBegin)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if let yearIndex = self.yearDataBR.value.firstIndex(of: self.selectedYear) {
                    self.yearPickerView.selectRow(yearIndex, inComponent: 0, animated: false)
                }
            }).disposed(by: disposeBag)
        
        monthTextField.rx.controlEvent(.editingDidBegin)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if let monthIndex = self.monthDataBR.value.firstIndex(of: self.selectedMonth) {
                    self.monthPickerView.selectRow(monthIndex, inComponent: 0, animated: false)
                }
            }).disposed(by: disposeBag)
        
        dayTextField.rx.controlEvent(.editingDidBegin)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if let dayIndex = self.dayDataBR.value.firstIndex(of: self.selectedDay) {
                    self.dayPickerView.selectRow(dayIndex, inComponent: 0, animated: false)
                }
            }).disposed(by: disposeBag)
        
        //연도 선택 시 동작
        doneButtonList[0].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let selectedRow = self.yearPickerView.selectedRow(inComponent: 0)
            self.yearTextField.text = String(self.yearDataBR.value[selectedRow])
            self.selectedYear = String(self.yearDataBR.value[selectedRow])
            self.yearTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        //연도 취소 시 동작
        cancelButtonList[0].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.yearTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        
        //월 선택 시 동작
        doneButtonList[1].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let selectedRow = self.monthPickerView.selectedRow(inComponent: 0)
            self.monthTextField.text = self.monthDataBR.value[selectedRow]
            self.selectedMonth = self.monthDataBR.value[selectedRow]
            self.monthTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        //월 취소 시 동작
        cancelButtonList[1].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.monthTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        //일 선택 시 동작
        doneButtonList[2].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let selectedRow = self.dayPickerView.selectedRow(inComponent: 0)
            self.dayTextField.text = String(self.dayDataBR.value[selectedRow])
            self.selectedDay = String(self.dayDataBR.value[selectedRow])
            self.dayTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        //일 취소 시 동작
        cancelButtonList[2].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.dayTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        //월 입력 값에 따라 일 입력 법위 조정
        monthTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] selectedMonth in
            guard let self = self else { return }
            switch selectedMonth {
            case "1월","3월","5월","7월","8월","10월","12월":
                let dayArray = Array(1...31).map({ String($0) })
                self.dayDataBR.accept(dayArray)
            case "4월","6월","9월","11월":
                let dayArray = Array(1...30).map({ String($0) })
                self.dayDataBR.accept(dayArray)
            case "2월":
                let dayArray = Array(1...28).map({ String($0) })
                self.dayDataBR.accept(dayArray)
            default:
                self.dayDataBR.accept([])
            }
        }).disposed(by: disposeBag)
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var yearTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.addRightImage(image: UIImage(systemName: "arrowtriangle.down.fill")!)
        textField.rightView?.tintColor = .lightGray
        textField.tintColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var monthTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.addRightImage(image: UIImage(systemName: "arrowtriangle.down.fill")!)
        textField.rightView?.tintColor = .lightGray
        textField.tintColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var dayTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.addRightImage(image: UIImage(systemName: "arrowtriangle.down.fill")!)
        textField.rightView?.tintColor = .lightGray
        textField.tintColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
}


