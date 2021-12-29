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
    
    let disposedBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.backgroundColor = .systemBlue
        
        setStyle()
        setLayout()
        setLimitForPicker()
        bindPickerToolbar()
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
    
    private func setLimitForPicker() {
        let now = Date()
        let calender = Calendar.current
        let currentYear = calender.component(.year, from: now)
        let currentMonth = calender.component(.month, from: now)
        
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
        
    }
    
    private func setLayout() {
        switch self.cellStyle {
        case .startDateStyle:
            self.contentView.addSubview(dateKindLabel)
            dateKindLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dateKindLabel.heightAnchor.constraint(equalToConstant: 15),
                dateKindLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
                dateKindLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15)
            ])
            
            self.contentView.addSubview(textFieldHorizontalStackView)
            textFieldHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                textFieldHorizontalStackView.widthAnchor.constraint(equalToConstant: 275),
                textFieldHorizontalStackView.topAnchor.constraint(equalTo: dateKindLabel.bottomAnchor, constant: 5),
                textFieldHorizontalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
                textFieldHorizontalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            ])
            
            textFieldHorizontalStackView.addArrangedSubview(yearTextField)
            yearTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                yearTextField.heightAnchor.constraint(equalToConstant: 35),
                yearTextField.widthAnchor.constraint(equalToConstant: 80),
                yearTextField.leadingAnchor.constraint(equalTo: textFieldHorizontalStackView.leadingAnchor, constant: 15),
                yearTextField.bottomAnchor.constraint(equalTo: textFieldHorizontalStackView.bottomAnchor)
            ])
            
            textFieldHorizontalStackView.addArrangedSubview(monthTextField)
            monthTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                monthTextField.heightAnchor.constraint(equalToConstant: 35),
                monthTextField.widthAnchor.constraint(equalToConstant: 80),
                monthTextField.bottomAnchor.constraint(equalTo: textFieldHorizontalStackView.bottomAnchor)
            ])
            
            textFieldHorizontalStackView.addArrangedSubview(dayTextField)
            dayTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dayTextField.heightAnchor.constraint(equalToConstant: 35),
                dayTextField.widthAnchor.constraint(equalToConstant: 80),
                dayTextField.bottomAnchor.constraint(equalTo: textFieldHorizontalStackView.bottomAnchor)
            ])
        case .endDateStyle:
            self.contentView.addSubview(dateKindLabel)
            dateKindLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dateKindLabel.heightAnchor.constraint(equalToConstant: 15),
                dateKindLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
                dateKindLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15)
            ])
            
            self.contentView.addSubview(textFieldHorizontalStackView)
            textFieldHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                textFieldHorizontalStackView.widthAnchor.constraint(equalToConstant: 275),
                textFieldHorizontalStackView.topAnchor.constraint(equalTo: dateKindLabel.bottomAnchor, constant: 5),
                textFieldHorizontalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
                textFieldHorizontalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            ])
            
            textFieldHorizontalStackView.addArrangedSubview(addDateLabel)
            addDateLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                addDateLabel.topAnchor.constraint(equalTo: textFieldHorizontalStackView.topAnchor),
                addDateLabel.bottomAnchor.constraint(equalTo: textFieldHorizontalStackView.bottomAnchor),
                addDateLabel.leadingAnchor.constraint(equalTo: textFieldHorizontalStackView.leadingAnchor, constant: 15)
            ])
        }
    }
    
    private func bindPickerToolbar() {
        yearDataBR.bind(to: yearPickerView.rx.itemTitles) { (row, element) in
            return "\(element)"
        }.disposed(by: disposedBag)
        
        monthDataBR.bind(to: monthPickerView.rx.itemTitles) { (row, element) in
            return element
        }.disposed(by: disposedBag)
        
        dayDataBR.bind(to: dayPickerView.rx.itemTitles) { (row, element) in
            return "\(element)"
        }.disposed(by: disposedBag)
        
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
            
            self.textFieldHorizontalStackView.addArrangedSubview(self.monthTextField)
        }.disposed(by: disposedBag)
        
        deleteButtonList[0].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.yearTextField.text = ""
            self.yearTextField.rightViewMode = .never
            self.yearTextField.leftViewMode = .always
            self.yearTextField.endEditing(true)
        }.disposed(by: disposedBag)
        
        cancelButtonList[0].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.yearTextField.endEditing(true)
        }.disposed(by: disposedBag)
        
        doneButtonList[1].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let selectedRow = self.monthPickerView.selectedRow(inComponent: 0)
            self.monthTextField.text = self.monthDataBR.value[selectedRow]
            self.monthTextField.rightViewMode = .always
            self.monthTextField.leftViewMode = .never
            self.monthTextField.endEditing(true)
            
            self.textFieldHorizontalStackView.addArrangedSubview(self.dayTextField)
        }.disposed(by: disposedBag)
        
        deleteButtonList[1].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.monthTextField.text = ""
            self.monthTextField.rightViewMode = .never
            self.monthTextField.leftViewMode = .always
            self.monthTextField.endEditing(true)
            
            self.textFieldHorizontalStackView.removeArrangedSubview(self.dayTextField)
        }.disposed(by: disposedBag)
        
        cancelButtonList[1].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.monthTextField.endEditing(true)
        }.disposed(by: disposedBag)
        
        doneButtonList[2].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let selectedRow = self.dayPickerView.selectedRow(inComponent: 0)
            self.dayTextField.text = String(self.dayDataBR.value[selectedRow])
            self.dayTextField.rightViewMode = .always
            self.dayTextField.leftViewMode = .never
            self.dayTextField.endEditing(true)
        }.disposed(by: disposedBag)
        
        deleteButtonList[2].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.dayTextField.text = ""
            self.dayTextField.rightViewMode = .never
            self.dayTextField.leftViewMode = .always
            self.dayTextField.endEditing(true)
            
        }.disposed(by: disposedBag)
        
        cancelButtonList[2].rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.dayTextField.endEditing(true)
        }.disposed(by: disposedBag)
        
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
        }).disposed(by: disposedBag)
    }
    
    lazy var dateKindLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private lazy var textFieldHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.axis = .horizontal
        stack.contentMode = .center
        stack.distribution = .fillProportionally
        stack.spacing = 10
        
        return stack
    }()
    
    lazy var addDateLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .darkGray
        
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
