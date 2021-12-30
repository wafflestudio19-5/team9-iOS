//
//  DateSelectTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class DateSelectTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DataSelectTableViewCell"
    
    let yearPickerView = UIPickerView()
    let monthPickerView = UIPickerView()
    let dayPickerView = UIPickerView()
    let yearPickerToolbar = UIToolbar()
    let monthPickerToolbar = UIToolbar()
    let dayPickerToolbar = UIToolbar()
    
    let doneButtonList = [UIBarButtonItem(title: "확인", style: .plain, target: nil, action: nil),
                          UIBarButtonItem(title: "확인", style: .plain, target: nil, action: nil),
                          UIBarButtonItem(title: "확인", style: .plain, target: nil, action: nil)]
    let deleteButtonList = [UIBarButtonItem(title: "삭제", style: .plain, target: nil, action: nil),
                            UIBarButtonItem(title: "삭제", style: .plain, target: nil, action: nil),
                            UIBarButtonItem(title: "삭제", style: .plain, target: nil, action: nil)]
    let flexibleSpaceList = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                             UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                             UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
    let cancelButtonList = [UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil),
                            UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil),
                            UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)]
    
    var yearDataBR: BehaviorRelay<[Int]> = BehaviorRelay<[Int]>(value: [])
    let monthDataBR: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"])
    var dayDataBR: BehaviorRelay<[Int]> = BehaviorRelay<[Int]>(value: [])
    
    private let year = BehaviorRelay<String>(value: "")
    private let month = BehaviorRelay<String>(value: "")
    private let day = BehaviorRelay<String>(value: "")
    
    enum Style {
        case startDateStyle
        case endDateStyle
    }
    
    var cellStyle: Style = .startDateStyle
    
    var disposeBag = DisposeBag()
    
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
        bindPickerToolbar()
        setDataForPicker()
    }
    
    func configureCell() {
        switch self.cellStyle {
        case .startDateStyle:
            dateKindLabel.text = "시작 날짜"
            
            let now = Date()
            let calender = Calendar.current
            let currentYear = calender.component(.year, from: now)
            let currentMonth = calender.component(.month, from: now)
            let currentDay = calender.component(.day, from: now)
            
            yearTextField.text = String(currentYear)
            monthTextField.text = "\(currentMonth)월"
            dayTextField.text = String(currentDay)
            
        case .endDateStyle:
            dateKindLabel.text = "종료 날짜"
        }
    }
    
    private func setStyle() {
        yearPickerToolbar.sizeToFit()
        monthPickerToolbar.sizeToFit()
        dayPickerToolbar.sizeToFit()
        
        yearPickerToolbar.setItems([cancelButtonList[0], flexibleSpaceList[0], deleteButtonList[0], doneButtonList[0]], animated: true)
        monthPickerToolbar.setItems([cancelButtonList[1], flexibleSpaceList[1], deleteButtonList[1], doneButtonList[1]], animated: true)
        dayPickerToolbar.setItems([cancelButtonList[2], flexibleSpaceList[2], deleteButtonList[2], doneButtonList[2]], animated: true)
        
        yearTextField.inputAccessoryView = yearPickerToolbar
        yearTextField.inputView = yearPickerView
        monthTextField.inputAccessoryView = monthPickerToolbar
        monthTextField.inputView = monthPickerView
        dayTextField.inputAccessoryView = dayPickerToolbar
        dayTextField.inputView = dayPickerView
        
        switch self.cellStyle {
        case .startDateStyle:
            yearTextField.leftViewMode = .never
            yearTextField.rightViewMode = .always
            monthTextField.leftViewMode = .never
            monthTextField.rightViewMode = .always
            dayTextField.leftViewMode = .never
            dayTextField.rightViewMode = .always
            
            addDateLabel.text = "시작 날짜"
        case .endDateStyle:
            yearTextField.leftViewMode = .always
            yearTextField.rightViewMode = .never
            monthTextField.leftViewMode = .always
            monthTextField.rightViewMode = .never
            dayTextField.leftViewMode = .always
            dayTextField.rightViewMode = .never
            
            addDateLabel.text = "종료 날짜"
        }
    }
    
    private func setLayout() {
        self.contentView.addSubview(dateKindLabel)
        dateKindLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            dateKindLabel.heightAnchor.constraint(equalToConstant: 15),
            dateKindLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            dateKindLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10)
        ])
        
        self.contentView.addSubview(addDateLabel)
        addDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addDateLabel.heightAnchor.constraint(equalToConstant: 25),
            addDateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            addDateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        
        self.contentView.addSubview(yearTextField)
        yearTextField.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            yearTextField.heightAnchor.constraint(equalToConstant: 25),
            yearTextField.topAnchor.constraint(equalTo: dateKindLabel.bottomAnchor, constant: 10),
            yearTextField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            yearTextField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        
        self.contentView.addSubview(monthTextField)
        monthTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            monthTextField.heightAnchor.constraint(equalToConstant: 25),
            monthTextField.leadingAnchor.constraint(equalTo: yearTextField.trailingAnchor, constant: 10),
            monthTextField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        
        self.contentView.addSubview(dayTextField)
        dayTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayTextField.heightAnchor.constraint(equalToConstant: 25),
            dayTextField.leadingAnchor.constraint(equalTo: monthTextField.trailingAnchor, constant: 10),
            dayTextField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        
        switch self.cellStyle {
        case .startDateStyle:
            hideAddDateLabel()
            showYearTextField()
            showMonthTextField()
            showDayTextField()
        case .endDateStyle:
            showAddDateLabel()
            hideYearTextField()
            hideMonthTextField()
            hideDayTextField()
        }
    }
    
    private func setDataForPicker() {
        let now = Date()
        let calender = Calendar.current
        let currentYear = calender.component(.year, from: now)
        let currentMonth = calender.component(.month, from: now)
        let currentDay = calender.component(.day, from: now)
        
        yearDataBR.accept(Array(1905...currentYear))
        
        switch currentMonth {
        case 1,3,5,7,8,10,12:
            dayDataBR.accept(Array(1...31))
        case 4,6,9,11:
            dayDataBR.accept(Array(1...30))
        case 2:
            dayDataBR.accept(Array(1...28))
        default:
            dayDataBR.accept([])
        }
        
        yearPickerView.selectRow(yearDataBR.value.count - 1, inComponent: 0, animated: false)
        monthPickerView.selectRow(currentMonth - 1, inComponent: 0, animated: false)
        dayPickerView.selectRow(currentDay - 1, inComponent: 0, animated: false)
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
        
        addDateLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            print("tap label")
            self.yearTextField.becomeFirstResponder()
        })
        
        doneButtonList[0].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let selectedRow = self.yearPickerView.selectedRow(inComponent: 0)
            self.yearTextField.text = String(self.yearDataBR.value[selectedRow])
            self.yearTextField.rightViewMode = .always
            self.yearTextField.leftViewMode = .never
            self.yearTextField.endEditing(true)
            
            self.hideAddDateLabel()
            self.showYearTextField()
            self.showMonthTextField()
        }.disposed(by: disposeBag)
        
        deleteButtonList[0].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.yearTextField.text = ""
            self.yearTextField.rightViewMode = .never
            self.yearTextField.leftViewMode = .always
            self.yearTextField.endEditing(true)
            
            self.showAddDateLabel()
            self.hideYearTextField()
            self.hideDayTextField()
            self.hideMonthTextField()
        }.disposed(by: disposeBag)
        
        cancelButtonList[0].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.yearTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        doneButtonList[1].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let selectedRow = self.monthPickerView.selectedRow(inComponent: 0)
            self.monthTextField.text = self.monthDataBR.value[selectedRow]
            self.monthTextField.rightViewMode = .always
            self.monthTextField.leftViewMode = .never
            self.monthTextField.endEditing(true)
            
            self.showDayTextField()
        }.disposed(by: disposeBag)
        
        deleteButtonList[1].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.monthTextField.text = ""
            self.monthTextField.rightViewMode = .never
            self.monthTextField.leftViewMode = .always
            self.monthTextField.endEditing(true)
            
            self.hideDayTextField()
        }.disposed(by: disposeBag)
        
        cancelButtonList[1].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.monthTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        doneButtonList[2].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let selectedRow = self.dayPickerView.selectedRow(inComponent: 0)
            self.dayTextField.text = String(self.dayDataBR.value[selectedRow])
            self.dayTextField.rightViewMode = .always
            self.dayTextField.leftViewMode = .never
            self.dayTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        deleteButtonList[2].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.dayTextField.text = ""
            self.dayTextField.rightViewMode = .never
            self.dayTextField.leftViewMode = .always
            self.dayTextField.endEditing(true)
            
        }.disposed(by: disposeBag)
        
        cancelButtonList[2].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.dayTextField.endEditing(true)
        }.disposed(by: disposeBag)
        
        monthTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] selectedMonth in
            guard let self = self else { return }
            switch selectedMonth {
            case "1월","3월","5월","7월","8월","10월","12월":
                self.dayDataBR.accept(Array(1...31))
            case "4월","6월","9월","11월":
                self.dayDataBR.accept(Array(1...30))
            case "2월":
                self.dayDataBR.accept(Array(1...28))
            default:
                self.dayDataBR.accept([])
            }
        }).disposed(by: disposeBag)
    }
    
    private func showAddDateLabel() {
        if addDateLabel.isHidden {
            addDateLabel.isHidden = false
        }
    }
    
    private func showYearTextField() {
        if yearTextField.isHidden {
            yearTextField.isHidden = false
        }
    }
    
    private func showMonthTextField() {
        if monthTextField.isHidden {
            monthTextField.isHidden = false
        }
    }
    
    private func showDayTextField() {
        if dayTextField.isHidden {
            dayTextField.isHidden = false
        }
    }
    
    private func hideAddDateLabel() {
        if !addDateLabel.isHidden {
            addDateLabel.isHidden = true
        }
    }
    
    private func hideYearTextField() {
        if !yearTextField.isHidden {
            yearTextField.isHidden = true
            yearTextField.text = ""
        }
    }
    
    private func hideMonthTextField() {
        if !monthTextField.isHidden {
            monthTextField.isHidden = true
            monthTextField.text = ""
        }
    }
    
    private func hideDayTextField() {
        if !dayTextField.isHidden {
            dayTextField.isHidden = true
            dayTextField.text = ""
        }
    }
    
    lazy var dateKindLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    lazy var addDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.tintColor = .lightGray
        
        return label
    }()

    lazy var yearTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.contentMode = .center
        
        textField.attributedPlaceholder = NSAttributedString(string: "연도 추가", attributes:[ NSAttributedString.Key.foregroundColor : UIColor.darkGray,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
        ])
        
        textField.addLeftimage(image: UIImage(systemName: "plus")!)
        textField.addRightImage(image: UIImage(systemName: "chevron.down")!)

        textField.font = UIFont.systemFont(ofSize: 14)
        
        return textField
    }()
    
    lazy var monthTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.contentMode = .center
        
        textField.attributedPlaceholder = NSAttributedString(string: "월 추가", attributes:[ NSAttributedString.Key.foregroundColor : UIColor.darkGray,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
        ])
        
        textField.addLeftimage(image: UIImage(systemName: "plus")!)
        textField.addRightImage(image: UIImage(systemName: "chevron.down")!)
        
        textField.font = UIFont.systemFont(ofSize: 14)
        
        return textField
    }()
    
    lazy var dayTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.contentMode = .center
        
        textField.attributedPlaceholder = NSAttributedString(string: "일 추가", attributes:[ NSAttributedString.Key.foregroundColor : UIColor.darkGray,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
        ])
        
        textField.addLeftimage(image: UIImage(systemName: "plus")!)
        textField.addRightImage(image: UIImage(systemName: "chevron.down")!)
        
        textField.font = UIFont.systemFont(ofSize: 14)
        
        return textField
    }()
}

extension UITextField {
    func addLeftimage(image:UIImage) {
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftImage.image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5))
        leftImage.contentMode = .center
        
        self.leftView = leftImage
        self.leftViewMode = .always
    }
    
    func addRightImage(image: UIImage) {
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightImage.image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5))
        rightImage.contentMode = .center
        
        self.rightView = rightImage
        self.rightViewMode = .always
    }
}
