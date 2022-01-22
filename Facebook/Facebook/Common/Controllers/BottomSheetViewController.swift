//
//  BottomSheetViewController.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

struct Menu {
    let image: UIImage
    let text: String
    let action: (() -> ())
}

class BottomSheetViewController<View: BottomSheetView>: UIViewController {

    private let disposeBag = DisposeBag()
    
    enum BottomSheetViewState {
        case expanded
        case normal
    }
    
    override func loadView() {
        view = View()
    }

    var bottomSheetView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    var tableView: UITableView {
        bottomSheetView.bottomSheetTableView
    }
    
    var contentViewHeight: CGFloat = 0
    var bottomSheetPanMinTopConstant: CGFloat = 30.0
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant
    var menuBR: BehaviorRelay<[Menu]> = BehaviorRelay<[Menu]>(value: [])
    
    init(menuList: [Menu]) {
        super.init(nibName: nil, bundle: nil)
        self.menuBR.accept(menuList)
        contentViewHeight = CGFloat(menuBR.value.count * 60 + 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showBottomSheet()
    }
    
    private func showBottomSheet(atState: BottomSheetViewState = .normal) {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        
        if atState == .normal {
            bottomSheetView.bottomSheetViewTopConstraint.constant = safeAreaHeight - contentViewHeight
        } else {
            bottomSheetView.bottomSheetViewTopConstraint.constant = bottomSheetPanMinTopConstant
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.bottomSheetView.dimmedView.alpha = 0.5
            self.bottomSheetView.contentView.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheet(afterAction: (() -> ())? = nil) {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetView.bottomSheetViewTopConstraint.constant = safeAreaHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.bottomSheetView.dimmedView.alpha = 0.0
            self.bottomSheetView.contentView.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: nil)
            (afterAction ?? {})()
            }
        }
    }
   
    private func bind() {
        menuBR.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: BottomSheetCell.reuseIdentifier, cellType: BottomSheetCell.self)) {  row, menu, cell in
                cell.configureCell(image: menu.image, text: menu.text)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] idxPath in
                self?.tableView.deselectRow(at: idxPath, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Menu.self)
            .subscribe(onNext: { [weak self] menu in
                self?.hideBottomSheet(afterAction: menu.action)
            }).disposed(by: disposeBag)
        
        view.rx
            .panGesture()
            .when(.began)
            .bind { [weak self] recognizer in
                guard let self = self else { return }
                self.bottomSheetPanStartingTopConstant = self.bottomSheetView.bottomSheetViewTopConstraint.constant
            }.disposed(by: disposeBag)
        
        view.rx
            .panGesture()
            .when(.changed)
            .bind { [weak self] recognizer in
                guard let self = self else { return }
                let transition = recognizer.translation(in: self.view).y
                let velocity = recognizer.velocity(in: self.view)
                
                //빠르게 아래로 스와이프 시 뷰 dismiss
                if velocity.y > 5000 {
                    self.hideBottomSheet()
                    return
                }
                
                if self.bottomSheetPanStartingTopConstant + transition > self.bottomSheetPanMinTopConstant {
                    self.bottomSheetView.bottomSheetViewTopConstraint.constant = self.bottomSheetPanStartingTopConstant + transition
                }
                
                self.bottomSheetView.dimmedView.alpha = self.dimAlphaWithBottomSheetTopConstraint(value: self.bottomSheetView.bottomSheetViewTopConstraint.constant)
            }.disposed(by: disposeBag)
        
        view.rx
            .panGesture()
            .when(.ended)
            .bind { [weak self] _ in
                guard let self = self else { return }
                let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
                let bottomPadding = self.view.safeAreaInsets.bottom
                        
                let defaultPadding = safeAreaHeight - self.contentViewHeight
                        
                let nearestValue = self.nearest(to: self.bottomSheetView.bottomSheetViewTopConstraint.constant, inValues: [defaultPadding, safeAreaHeight + bottomPadding])
                        
                if nearestValue == defaultPadding {
                    self.showBottomSheet(atState: .normal)
                } else {
                    self.hideBottomSheet()
                }
                
            }.disposed(by: disposeBag)
    }
    
    private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }
    
    private func dimAlphaWithBottomSheetTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha: CGFloat = 0.7
        
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = self.view.safeAreaInsets.bottom
        
        // bottom sheet의 top constraint 값이 fullDimPosition과 같으면
        // dimmer view의 alpha 값이 0.7이 되도록 합니다
        let fullDimPosition = (safeAreaHeight + contentViewHeight) / 2

        // bottom sheet의 top constraint 값이 noDimPosition과 같으면
        // dimmer view의 alpha 값이 0.0이 되도록 합니다
        let noDimPosition = safeAreaHeight + bottomPadding

        // Bottom Sheet의 top constraint 값이 fullDimPosition보다 작으면
        // 배경색이 가장 진해진 상태로 지정해줍니다.
        if value < fullDimPosition {
            return fullDimAlpha
        }
        // Bottom Sheet의 top constraint 값이 noDimPosition보다 크면
        // 배경색이 투명한 상태로 지정해줍니다.
        if value > noDimPosition {
            return 0.0
        }
        
        // 그 외의 경우 top constraint 값에 따라 0.0과 0.7 사이의 alpha 값이 Return되도록 합니다
        return fullDimAlpha * (1 - ((value - fullDimPosition) / (noDimPosition - fullDimPosition)))
    }
    
    
}
