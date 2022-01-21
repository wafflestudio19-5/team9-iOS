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
    
    var contentViewHeight: CGFloat = 300
    var maxHeight: CGFloat = 0
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = contentViewHeight
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        showBottomSheet()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        maxHeight = view.safeAreaLayoutGuide.layoutFrame.height - 30
    }
    
    private func showBottomSheet(atState: BottomSheetViewState = .normal) {
        if atState == .normal {
            bottomSheetView.contentViewHeightConstraint.constant = contentViewHeight
        } else {
            bottomSheetView.contentViewHeightConstraint.constant = maxHeight
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.bottomSheetView.dimmedView.alpha = 0.5
            self.bottomSheetView.contentView.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheet() {
        bottomSheetView.contentViewHeightConstraint.constant = 0
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.bottomSheetView.dimmedView.alpha = 0.0
            self.bottomSheetView.contentView.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: nil)
            }
        }
    }
   
    private func bind() {
        view.rx
            .panGesture()
            .when(.began)
            .bind { [weak self] recognizer in
                guard let self = self else { return }
                self.bottomSheetPanStartingTopConstant = self.bottomSheetView.contentViewHeightConstraint.constant
            }.disposed(by: disposeBag)
        
        view.rx
            .panGesture()
            .when(.changed)
            .bind { [weak self] recognizer in
                guard let self = self else { return }
                let transition = recognizer.translation(in: self.view).y
                let velocity = recognizer.velocity(in: self.view)
                
                //빠르게 아래로 스와이프 시 뷰 dismiss
                if velocity.y > 1500 {
                    self.hideBottomSheet()
                    return
                }
                
                if self.bottomSheetPanStartingTopConstant - transition < self.maxHeight {
                    self.bottomSheetView.contentViewHeightConstraint.constant = self.bottomSheetPanStartingTopConstant - transition
                }
                
                self.bottomSheetView.dimmedView.alpha = self.dimAlphaWithBottomSheetHeight(value: self.bottomSheetView.contentViewHeightConstraint.constant)
            }.disposed(by: disposeBag)
        
        view.rx
            .panGesture()
            .when(.ended)
            .bind { [weak self] _ in
                guard let self = self else { return }
                let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
                
                let nearestValue = self.nearest(to: self.bottomSheetView.contentViewHeightConstraint.constant, inValues: [0, self.contentViewHeight])
                
                if nearestValue == safeAreaHeight {
                    self.showBottomSheet(atState: .expanded)
                } else if nearestValue == self.contentViewHeight {
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
    
    private func dimAlphaWithBottomSheetHeight(value: CGFloat) -> CGFloat {
        let fullDimAlpha: CGFloat = 0.7
        
        if value < maxHeight {
            return fullDimAlpha
        }
            // Bottom Sheet의 top constraint 값이 noDimPosition보다 크면
            // 배경색이 투명한 상태로 지정해줍니다.
        if value > 0 {
            return 0.0
        }
            // 그 외의 경우 top constraint 값에 따라 0.0과 0.7 사이의 alpha 값이 Return되도록 합니다
        return fullDimAlpha * (1 - (maxHeight - value) / contentViewHeight)
    }
}
