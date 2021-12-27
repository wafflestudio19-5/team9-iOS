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
    
    let doneButton = UIBarButtonItem(title: "확인", style: .plain, target: nil, action: nil)
    let deleteButton = UIBarButtonItem(title: "삭제", style: .plain, target: nil, action: nil)
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
    
    var yearData: [Int] = [Int]()
    let monthData = ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"]
    var dayData: [Int] = [Int]()
    
    enum Style {
        case startDateStyle
        case endDateStyle
    }
    
    let disposedBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .systemBlue
        setStyle()
        setLimitForPicker()
        bindPickerToolbar()
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
    
    func configureCell(style: Style) {
        switch style {
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
    
    func setStyle() {
        yearPickerToolbar.sizeToFit()
        monthPickerToolbar.sizeToFit()
        dayPickerToolbar.sizeToFit()
        
        yearPickerToolbar.setItems([cancelButton, flexibleSpace, deleteButton, doneButton], animated: true)
        monthPickerToolbar.setItems([cancelButton, flexibleSpace, deleteButton, doneButton], animated: true)
        dayPickerToolbar.setItems([cancelButton, flexibleSpace, deleteButton, doneButton], animated: true)
        
        yearTextField.inputAccessoryView = yearPickerToolbar
        yearTextField.inputView = yearPickerView
        monthTextField.inputAccessoryView = monthPickerToolbar
        monthTextField.inputView = monthPickerView
        dayTextField.inputAccessoryView = dayPickerToolbar
        dayTextField.inputView = dayPickerView
    }
    
    func setLimitForPicker() {
        let now = Date()
        let calender = Calendar.current
        let currentYear = calender.component(.year, from: now)
        
        yearData = Array(1905...currentYear)
    }
    
    func setLayout(style: Style) {
        switch style {
        case .startDateStyle:
            self.addSubview(dateKindLabel)
            dateKindLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dateKindLabel.heightAnchor.constraint(equalToConstant: 15),
                dateKindLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
                dateKindLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
            ])
            
            self.addSubview(yearTextField)
            yearTextField.layer.zPosition = 10
            yearTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                yearTextField.topAnchor.constraint(equalTo: dateKindLabel.bottomAnchor, constant: 10),
                yearTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
                yearTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
            ])
            
            self.addSubview(monthTextField)
            monthTextField.layer.zPosition = 10
            monthTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                monthTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
                monthTextField.leadingAnchor.constraint(equalTo: yearTextField.trailingAnchor, constant: 15)
            ])
            
            self.addSubview(dayTextField)
            dayTextField.layer.zPosition = 10
            dayTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dayTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
                dayTextField.leadingAnchor.constraint(equalTo: monthTextField.trailingAnchor, constant: 15)
            ])
        case .endDateStyle:
            print("endDataStyle")
        }
    }
    
    func bindPickerToolbar() {
        Observable.just(yearData).bind(to: yearPickerView.rx.itemTitles) { (row, element) in
            return "\(element)"
        }.disposed(by: disposedBag)
        
        Observable.just(monthData).bind(to: monthPickerView.rx.itemTitles) { (row, element) in
            return "element"
        }.disposed(by: disposedBag)
        
        Observable.just(dayData).bind(to: dayPickerView.rx.itemTitles) { (row, element) in
            return "\(element)"
        }.disposed(by: disposedBag)

        yearTextField.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            print("tap")
        }).disposed(by: disposedBag)
    }
    
    lazy var dateKindLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()

    lazy var yearTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        textField.attributedPlaceholder = NSAttributedString(string: "연도 추가", attributes:[ NSAttributedString.Key.foregroundColor : UIColor.darkGray,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
        ])
        
        textField.addLeftPadding()
        textField.addLeftimage(image: UIImage(systemName: "plus")!)
        
        textField.font = UIFont.systemFont(ofSize: 14)
    
        
        return textField
    }()
    
    lazy var monthTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        textField.attributedPlaceholder = NSAttributedString(string: "월 추가", attributes:[ NSAttributedString.Key.foregroundColor : UIColor.darkGray,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
        ])
        
        textField.addLeftPadding()
        textField.addLeftimage(image: UIImage(systemName: "plus")!)
        
        textField.font = UIFont.systemFont(ofSize: 14)
        
        return textField
    }()
    
    lazy var dayTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        textField.attributedPlaceholder = NSAttributedString(string: "일 추가", attributes:[ NSAttributedString.Key.foregroundColor : UIColor.darkGray,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
        ])
        
        textField.addLeftimage(image: UIImage(systemName: "plus")!)
        
        textField.font = UIFont.systemFont(ofSize: 14)
        
        return textField
    }()
}

extension UITextField {
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
    
    func addLeftimage(image:UIImage) {
        let leftimage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        leftimage.image = image
        self.leftView = leftimage
        self.leftViewMode = .always
    }
    
    func addRightImage(image: UIImage) {
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        rightImage.image = image
        self.rightView = rightImage
        self.rightViewMode = .always
    }
}
