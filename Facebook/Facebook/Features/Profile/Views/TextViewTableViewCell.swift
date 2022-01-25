//
//  TextFieldTableViewCell.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/30.
//

import UIKit
import RxSwift
import RxCocoa


class TextViewTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TextFieldTableViewCell"
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.width = UIScreen.main.bounds.width // important for initial layout
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

    func initialSetup() {
        setStyle()
        setLayout()
        setTextViewPlaceholder()
    }
    
    func configureCell(text: String) {
        if text != "" {
            textView.text = text
            textView.textColor = .black
        }
        else {
            textView.text = "직업에 대해 설명해주세요(선택 사항)"
        }
    }

    
    private func setStyle() {
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .gray
    }
    
    private func setLayout() {
        self.contentView.addSubview(textView)
        textView.snp.remakeConstraints { make in
            make.height.equalTo(80).priority(999)
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func setTextViewPlaceholder() {
        textView.rx.didBeginEditing.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if self.textView.text == "직업에 대해 설명해주세요(선택 사항)" {
                self.textView.text = nil
                self.textView.textColor = .black
            }
        }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if self.textView.text == nil || self.textView.text == "" {
                self.textView.text = "직업에 대해 설명해주세요(선택 사항)"
                self.textView.textColor = .gray
            }
        }).disposed(by: disposeBag)
    }
    
    let textView = UITextView()
}
