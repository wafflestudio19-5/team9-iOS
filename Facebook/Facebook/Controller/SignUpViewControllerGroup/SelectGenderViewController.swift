//
//  SelectGenderViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/12/09.
//

import RxSwift
import RxGesture

class SelectGenderViewController: BaseSignUpViewController<SelectGenderView>, UIScrollViewDelegate {
    
    private let optionsForGender = Observable.just(["여성", "남성"])

    override func viewDidLoad() {
        super.viewDidLoad()

        bindView()
    }
    
    private func bindView() {
        customView.genderTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        customView.genderTableView.register(GenderTableViewCell.self, forCellReuseIdentifier: GenderTableViewCell.genderTableViewCellID)
        
        optionsForGender.bind(to: customView.genderTableView.rx.items(cellIdentifier: GenderTableViewCell.genderTableViewCellID, cellType: GenderTableViewCell.self)) { _ , gender, cell in
            cell.setLabelText(as: gender)
        }.disposed(by: disposeBag)
        
        // TODO: 서버에서 등록될 수 있는 타입으로의 변환(필요할 시)
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
        
        customView.nextButton.rx.tap.bind {
            let enterPasswordViewController = EnterPasswordViewController()
            self.navigationController?.pushViewController(enterPasswordViewController, animated: true)
        }.disposed(by: disposeBag)
    }
}
