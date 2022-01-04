//
//  PlaceholderTextView.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/04.
//

import UIKit
import RxSwift
import RxCocoa

class PlaceholderTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        placeholderTextView.font = font
        addSubview(placeholderTextView)
        NSLayoutConstraint.activate([
            placeholderTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            placeholderTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            placeholderTextView.topAnchor.constraint(equalTo: self.topAnchor),
            placeholderTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        bindTextInputEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var placeholder: String? {
        get {
            return placeholderTextView.text
        }
        set {
            placeholderTextView.text = newValue
        }
    }
    
    override var text: String! {
        didSet {
            invalidateIntrinsicContentSize()
            placeholderTextView.isHidden = !text.isEmpty
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderTextView.font = font
            invalidateIntrinsicContentSize()
        }
    }
    
    private let placeholderTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        tv.textColor = UIColor.gray
        return tv
    }()
    
    lazy var isEmptyObservable: Observable<Bool> = {
        return self.rx.text.orEmpty.map { [weak self] (string: String?) -> Bool in
            guard let self = self else { return false }
            guard let string = string else {
                return false
            }
            return string.isEmpty
        }
    }()
    
    func bindTextInputEvent() {
        isEmptyObservable
            .observe(on: MainScheduler.instance)
            .bind { [weak self] isEmpty in
                guard let self = self else { return }
                self.placeholderTextView.isHidden = !isEmpty
                self.invalidateIntrinsicContentSize()
                
            }
            .disposed(by: disposeBag)
    }
}
