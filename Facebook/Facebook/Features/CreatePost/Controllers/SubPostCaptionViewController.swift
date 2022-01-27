//
//  EditSubPostViewController.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/26.
//

import UIKit
import RxSwift
import RxKeyboard

class SubPostCaptionViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let subPostViewModel: SubPostViewModel
    
    
    init(viewModel: SubPostViewModel) {
        self.subPostViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SubPostCaptionView()
    }
    
    var subpostCaptionView: SubPostCaptionView {
        guard let view = view as? SubPostCaptionView else { fatalError("CreatePostView is not loaded.") }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "편집"
        view.backgroundColor = .white
        bind()
        bindKeyboardHeight()
        setNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.scrollEdgeAppearance = nil
    }
    
    private func setNavBar() {
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = doneButton
        doneButton.rx.tap.bind { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    private func bindKeyboardHeight() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0) {
                    self.subpostCaptionView.subpostsTableView.contentInset.bottom = (keyboardVisibleHeight == 0 ? 0 : keyboardVisibleHeight  - self.view.safeAreaInsets.bottom)
                    self.subpostCaptionView.subpostsTableView.verticalScrollIndicatorInsets.bottom = self.subpostCaptionView.subpostsTableView.contentInset.bottom
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        subPostViewModel.prefetchImages()
        subPostViewModel.isPrefetching.bind { [weak self] prefetching in
            guard let self = self else { return }
            if prefetching {
                self.subpostCaptionView.subpostsTableView.showBottomSpinner()
            } else {
                self.subpostCaptionView.subpostsTableView.hideBottomSpinner()
            }
        }.disposed(by: disposeBag)
        
        subPostViewModel.prefetchedSubposts.bind(to: subpostCaptionView.subpostsTableView.rx.items(cellIdentifier: SubPostCaptionCell.reuseIdentifier, cellType: SubPostCaptionCell.self)) { [weak self] row, data, cell in
            guard let self = self else { return }
            cell.configure(subpost: data)
            
            cell.postContentView.captionTextView.rx.text.orEmpty.bind { [weak self] text in
                guard let self = self else { return }
                self.subPostViewModel.storeContents(row: row, content: text)
                self.subpostCaptionView.subpostsTableView.beginUpdates()
                self.subpostCaptionView.subpostsTableView.endUpdates()
            }.disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
    }
    
    
}
