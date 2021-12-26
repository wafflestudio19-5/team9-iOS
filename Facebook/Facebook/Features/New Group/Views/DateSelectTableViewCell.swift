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
    
    enum Style {
        case startDateStyle
        case endDateStyle
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .systemBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(style: Style) {
        switch style {
        case .startDateStyle:
            dateKindLabel.text = "시작 날짜"
            yearTextField.text = "2021"
            monthTextField.text = "12월"
            dayTextField.text = "26"
        case .endDateStyle:
            dateKindLabel.text = "종료 날짜"
        }
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
            yearTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                yearTextField.topAnchor.constraint(equalTo: dateKindLabel.bottomAnchor, constant: 3),
                yearTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
                yearTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
            ])
            
            self.addSubview(monthTextField)
            monthTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                monthTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
                monthTextField.leadingAnchor.constraint(equalTo: yearTextField.trailingAnchor, constant: 15)
            ])
            
            self.addSubview(dayTextField)
            dayTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dayTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
                dayTextField.leadingAnchor.constraint(equalTo: monthTextField.trailingAnchor, constant: 15)
            ])
        case .endDateStyle:
            print("endDataStyle")
        }
    }
    
    lazy var dateKindLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()

    lazy var yearTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        
        return textField
    }()
    
    lazy var monthTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        
        return textField
    }()
    
    lazy var dayTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        
        return textField
    }()
    
}
