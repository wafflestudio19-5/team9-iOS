//
//  SelectGenderViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import RxSwift
import RxGesture
import RxCocoa

class SelectGenderViewController: BaseSignUpViewController<SelectGenderView>, UIScrollViewDelegate {
    
    private enum GenderValidation {
        case valid
        case invalid
        
        init(gender: String) {
            if !gender.isEmpty { self = .valid }
            else { self = .invalid }
        }
        
        func message() -> String {
            switch self {
            case .valid: return ""
            case .invalid: return "성별을 선택하세요."
            }
        }
        
        func labelColor() -> UIColor {
            switch self {
            case .valid: return .black
            case .invalid: return .red
            }
        }
    }
    
    private let optionsForGender = Observable.just(["여성", "남성"])
    
    private let gender = BehaviorRelay<String>(value: "")
    
    private var isValidGender: GenderValidation?

    override func viewDidLoad() {
        super.viewDidLoad()

        bindView()
    }
    
    private func bindView() {
        customView.genderTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        customView.genderTableView.register(GenderTableViewCell.self, forCellReuseIdentifier: GenderTableViewCell.reuseIdentifier)
        
        optionsForGender.bind(to: customView.genderTableView.rx.items(cellIdentifier: GenderTableViewCell.reuseIdentifier, cellType: GenderTableViewCell.self)) { _ , gender, cell in
            cell.setLabelText(as: gender)
        }.disposed(by: disposeBag)
        
        // 선택된 model을 gender에 binding
        customView.genderTableView.rx
            .modelSelected(String.self)
            .bind(to: gender)
            .disposed(by: disposeBag)
        
        // gender을 토대로 isValidGender 초기화
        gender
            .bind { [weak self] gender in
                self?.isValidGender = GenderValidation.init(gender: gender)
            }.disposed(by: disposeBag)

        customView.genderTableView.rx
            .itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                guard let cell = self.customView.genderTableView.cellForRow(at: indexPath) as? GenderTableViewCell else { return }
                cell.isSelected = true
            }.disposed(by: disposeBag)
        
        customView.genderTableView.rx
            .itemDeselected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                guard let cell = self.customView.genderTableView.cellForRow(at: indexPath) as? GenderTableViewCell else { return }
                cell.isSelected = false
            }.disposed(by: disposeBag)
        
        customView.nextButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                guard let isValidGender = self.isValidGender else { return }
                
                self.customView.setAlertLabelText(as: isValidGender.message())
                self.changeLabelTextColorForCells(as: isValidGender.labelColor())
                
                if isValidGender == .valid {
                    self.push(viewController: EnterPasswordViewController())
                }
        }.disposed(by: disposeBag)
    }
}

extension SelectGenderViewController {
    private func changeLabelTextColorForCells(as color: UIColor) {
        guard let cells = self.customView.genderTableView.visibleCells as? [GenderTableViewCell] else { return }
        cells.forEach { $0.setLabelTextColor(as: color) }
    }
}
