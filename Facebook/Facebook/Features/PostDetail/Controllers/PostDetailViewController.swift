//
//  PostViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/05.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

class PostDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    var post: Post
    var asFirstResponder: Bool
    let disposeBag = DisposeBag()
    var hiddenTextView = UITextView()
    var didConfigurePostDetailView: Bool = false
    var initialInputAccessoryHeight: CGFloat?
    
    lazy var commentViewModel: PaginationViewModel<Comment> = {
        return PaginationViewModel<Comment>(endpoint: .comment(postId: 796))
    }()
    
    lazy var authorHeaderView: AuthorInfoHeaderView = {
        let view = AuthorInfoHeaderView(imageWidth: 40)
        view.configure(with: post)
        return view
    }()
    
    private lazy var leftChevronButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
        button.rx.tap.bind { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        return button
    }()
    
    
    init(post: Post, asFirstResponder: Bool = false) {
        self.post = post
        self.asFirstResponder = asFirstResponder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PostDetailView()
    }
    
    var postView: PostDetailView {
        guard let view = view as? PostDetailView else { fatalError("PostView가 제대로 초기화되지 않음.") }
        return view
    }
    
    var commentTableView: UITableView {
        return postView.commentTableView
    }
    
    func setLeftBarButtonItems() {
        let stackview = UIStackView.init(arrangedSubviews: [leftChevronButton, authorHeaderView])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 10
        
        let leftBarButtons = UIBarButtonItem(customView: stackview)
        navigationItem.leftBarButtonItem = leftBarButtons
    }
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        bindTableView()
        setLeftBarButtonItems()
        
        // firstResponder 관련 문제 workaround
//        view.addSubview(hiddenTextView)
//        hiddenTextView.isHidden = true
//        hiddenTextView.inputAccessoryView = keyboardAccessory
//        if self.asFirstResponder {
//            hiddenTextView.becomeFirstResponder()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if self.asFirstResponder && !textView.isFirstResponder {
//            textView.becomeFirstResponder()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialInputAccessoryHeight = self.inputAccessoryView.frame.height
        bindKeyboardHeight()
        if self.asFirstResponder && !textView.isFirstResponder {
            textView.becomeFirstResponder()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didConfigurePostDetailView {
            postView.postContentHeaderView.configure(with: post)
            didConfigurePostDetailView = true
        }
        postView.commentTableView.adjustHeaderHeight()
    }
    
    // MARK: Keyboard Accessory Logics
    
    override var inputAccessoryView: UIView {
        return self.keyboardAccessory
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // 올라갈떄 애니메이션 있고, 내려갈땐 없어야함
    private func bindKeyboardHeight() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0) {
                    let keyboardHeight = keyboardVisibleHeight - (self.initialInputAccessoryHeight ?? 0) + CGFloat.standardTopMargin
                    self.commentTableView.contentInset.bottom = keyboardHeight
                    self.commentTableView.scrollIndicatorInsets.bottom = self.commentTableView.contentInset.bottom
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Keyboard Accessory Components
    
    lazy var textView: FlexibleTextView = {
        let textView = FlexibleTextView()
        textView.placeholder = "댓글을 입력하세요..."
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .systemGroupedBackground
        textView.maxHeight = 80
        textView.layer.cornerRadius = 17
        textView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var sendButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "paperplane.fill")
        config.baseForegroundColor = FacebookColor.blue.color()
        
        let button = UIButton()
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        return button
    }()
    
    let photosButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "photo.on.rectangle.angled")
        config.cornerStyle = .capsule
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()
    
    let divider = Divider()
    
    lazy var keyboardAccessory: CustomInputAccessoryView = {
        let customInputView = CustomInputAccessoryView()
        
        customInputView.addSubview(textView)
        customInputView.addSubview(sendButton)
        customInputView.addSubview(divider)
        
        NSLayoutConstraint.activate([
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: customInputView.leadingAnchor, constant: .standardLeadingMargin),
            textView.topAnchor.constraint(equalTo: customInputView.topAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: customInputView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            sendButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 0),
            sendButton.trailingAnchor.constraint(equalTo: customInputView.trailingAnchor, constant: -8),
            sendButton.bottomAnchor.constraint(equalTo: customInputView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.topAnchor.constraint(equalTo: customInputView.topAnchor),
            divider.leadingAnchor.constraint(equalTo: customInputView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: customInputView.trailingAnchor),
        ])
        return customInputView
    }()
}

// MARK: Handle Comments

extension PostDetailViewController {
    
    /// Flatten nested comment data via preorder traversal.
    private func recursivelyFlatten(comments: [Comment]) -> [Comment] {
        var flatten: [Comment] = []
        
        func preorderTraversal(root: Comment) {
            flatten.append(root)
            for child in root.children {
                preorderTraversal(root: child)
            }
        }
        
        for comment in comments {
            preorderTraversal(root: comment)
        }
        return flatten
    }
    
    
    func bindTableView(){
        /// 댓글 데이터 테이블뷰 바인딩
        commentViewModel.dataList
            .observe(on: MainScheduler.instance)
            .map { [weak self] (comments: [Comment]) -> [Comment] in
                guard let self = self else { return comments }
                return self.recursivelyFlatten(comments: comments)
            }
            .bind(to: commentTableView.rx.items(cellIdentifier: CommentCell.reuseIdentifier, cellType: CommentCell.self)) { row, comment, cell in
                cell.configure(with: comment)
            }
            .disposed(by: disposeBag)
        
        /// `isLoading` 값이 바뀔 때마다 하단 스피너를 토글합니다.
        commentViewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.commentTableView.showBottomSpinner()
                } else {
                    self?.commentTableView.hideBottomSpinner()
                }
            })
            .disposed(by: disposeBag)
        
        /// 테이블 맨 아래까지 스크롤할 때마다 `loadMore` 함수를 실행합니다.
        commentTableView.rx.didScroll
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                let offSetY = self.commentTableView.contentOffset.y
                let contentHeight = self.commentTableView.contentSize.height
                if offSetY > (contentHeight - self.commentTableView.frame.size.height - 100) {
                    self.commentViewModel.loadMore()
                }
            }
            .disposed(by: disposeBag)
        
    }
    
}
