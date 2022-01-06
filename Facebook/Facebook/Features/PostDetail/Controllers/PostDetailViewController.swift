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
import SnapKit

class PostDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    var post: Post
    var asFirstResponder: Bool
    let disposeBag = DisposeBag()
    var hiddenTextView = UITextView()  // to be deprecated
    var didConfigurePostDetailView: Bool = false
    var initialInputAccessoryHeight: CGFloat?
    private var didSetupViewConstraints = false
    
    lazy var commentViewModel: PaginationViewModel<Comment> = {
        return PaginationViewModel<Comment>(endpoint: .comment(postId: 796))
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
    
    lazy var authorHeaderView: AuthorInfoHeaderView = {
        let view = AuthorInfoHeaderView(imageWidth: 40)
        view.configure(with: post)
        return view
    }()
    
    private lazy var leftChevronButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
        config.imagePadding = 0
        config.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 8)
        
        let button = UIButton.init(configuration: config)
        button.rx.tap.bind { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        return button
    }()
    
    func setLeftBarButtonItems() {
        let stackview = UIStackView.init(arrangedSubviews: [leftChevronButton, authorHeaderView])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 0
        
        let leftBarButtons = UIBarButtonItem(customView: stackview)
        navigationItem.leftBarButtonItem = leftBarButtons
    }
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//        appDelegate.window?.makeKeyAndVisible()
        bindKeyboardHeight()
        bindTableView()
        bindLikeButton()
        bindCommentButton()
        setLeftBarButtonItems()
        setKeyboardToolbar()
        
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
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        navigationController?.interactivePopGestureRecognizer!.isEnabled = true
        
        // tableView의 panGesture보다 swipe back 제스쳐가 우선이다.
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            commentTableView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialInputAccessoryHeight = 0
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
        if self.commentTableView.contentInset.bottom == 0 {
            self.commentTableView.contentInset.bottom = self.keyboardAccessory.frame.height
            self.commentTableView.verticalScrollIndicatorInsets.bottom = self.commentTableView.contentInset.bottom
        }
        postView.commentTableView.adjustHeaderHeight()
    }
    
    // MARK: Keyboard Accessory Logics
    
    var toolbarButtonConstraint: NSLayoutConstraint?
    private func setKeyboardToolbar() {
        postView.addSubview(keyboardAccessory)
        keyboardAccessory.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        print("updateViewConstraints")
        guard !self.didSetupViewConstraints else { return }
        self.didSetupViewConstraints = true
    }
    
    
    private func bindKeyboardHeight() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self, self.didSetupViewConstraints else { return }
                print(keyboardVisibleHeight)
                self.keyboardAccessory.snp.remakeConstraints { make in
                    make.left.right.equalTo(0)
                    make.bottom.equalTo(keyboardVisibleHeight == 0 ? self.view.safeAreaLayoutGuide.snp.bottom : self.view.snp.bottom).offset(-keyboardVisibleHeight)
                }
                
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0) {
                    
                    self.commentTableView.contentInset.bottom = keyboardVisibleHeight + self.keyboardAccessory.frame.height
                    self.commentTableView.verticalScrollIndicatorInsets.bottom = self.commentTableView.contentInset.bottom
                    self.view.layoutIfNeeded()
                    
                    //                    let keyboardHeight = keyboardVisibleHeight - (self.initialInputAccessoryHeight ?? 0) + CGFloat.standardTopMargin
                    //                    self.commentTableView.contentInset.bottom = keyboardHeight
                    //                    self.toolbarButtonConstraint?.constant = -keyboardVisibleHeight
                    //                    self.commentTableView.scrollIndicatorInsets.bottom = self.commentTableView.contentInset.bottom
                }
            })
            .disposed(by: disposeBag)
        
        //        RxKeyboard.instance.willShowVisibleHeight
        //            .drive(onNext: { [weak self] keyboardVisibleHeight in
        //                guard let self = self else { return }
        //                self.view.setNeedsLayout()
        //                UIView.animate(withDuration: 0) {
        //                    let keyboardHeight = keyboardVisibleHeight - (self.initialInputAccessoryHeight ?? 0) + CGFloat.standardTopMargin
        //                    self.commentTableView.contentInset.bottom = keyboardHeight
        //                    self.commentTableView.scrollIndicatorInsets.bottom = self.commentTableView.contentInset.bottom
        //                    self.view.layoutIfNeeded()
        //                }
        //            })
        //            .disposed(by: disposeBag)
    }
    
    // MARK: Keyboard Accessory Components
    
    lazy var textView: FlexibleTextView = {
        let textView = FlexibleTextView()
        textView.placeholder = "댓글을 입력하세요..."
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .grayscales.bubbleGray
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
    
    lazy var keyboardAccessory: UIView = {
        let customInputView = UIView()
        customInputView.backgroundColor = .red
        customInputView.addSubview(textView)
        customInputView.addSubview(sendButton)
        customInputView.addSubview(divider)
        
        NSLayoutConstraint.activate([
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
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

// MARK: Handle Buttons

extension PostDetailViewController {
    private func bindLikeButton() {
        postView.likeButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.postView.postContentHeaderView.like()
                NetworkService.put(endpoint: .newsfeedLike(postId: self.post.id), as: PostLikeResponse.self)
                    .bind { response in
                        self.postView.postContentHeaderView.like(syncWith: response.1)
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCommentButton() {
        postView.commentButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.textView.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
    }
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
