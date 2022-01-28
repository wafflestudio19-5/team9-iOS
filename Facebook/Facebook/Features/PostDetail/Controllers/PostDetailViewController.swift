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
import RxGesture

class PostDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    var post: Post
    var asFirstResponder: Bool
    let disposeBag = DisposeBag()
    var didConfigurePostDetailView: Bool = false
    var postRelay: BehaviorRelay<[Post]>  // stores current post
    
    /// 댓글 셀의 정보를 임시로 저장한다.
    struct FocusedItem {
        let row: Int
        let comment: Comment
        let cell: CommentCell
    }
    
    var focusedItem: FocusedItem? {
        willSet(newVal) {
            if newVal == nil || focusedItem?.row != newVal?.row {
                focusedItem?.cell.unfocus()
            }
        }
        didSet {
            guard let focusedItem = focusedItem else { return }
            focusedItem.cell.focus()
            postView.showFocusedInfo(with: focusedItem.comment.author.username)
        }
    }
    
    lazy var commentViewModel: CommentPaginationViewModel = {
        return CommentPaginationViewModel(endpoint: .comment(postId: post.id))
    }()
    
    init(post: Post, asFirstResponder: Bool = false) {
        self.post = post
        self.asFirstResponder = asFirstResponder
        self.postRelay = BehaviorRelay<[Post]>(value: [post])
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
    
    var keyboardAccessory: UIView {
        return postView.keyboardAccessory
    }
    
    var keyboardTextView: FlexibleTextView {
        return postView.textView
    }
    
    var postHeader: PostDetailHeaderView {
        return postView.postContentHeaderView
    }
    
    var loadPreviousButton: InfoButton {
        return postHeader.loadPreviousButton
    }
    
    func setNavBarItems() {
        // nav bar is hidden in this VC
    }
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView()
        bindReply()
        bindButtons()
        setNavBarItems()
        setKeyboardToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        navigationController?.interactivePopGestureRecognizer!.isEnabled = true
        
        // tableView의 panGesture보다 swipe back 제스쳐가 우선이다.
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            commentTableView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
        }
        
        bindKeyboardHeight()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.asFirstResponder && !keyboardTextView.isFirstResponder {
            keyboardTextView.becomeFirstResponder()
            self.asFirstResponder = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didConfigurePostDetailView {
            postView.configure(with: post)
            didConfigurePostDetailView = true
        }
        postView.commentTableView.adjustHeaderHeight()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: Keyboard Accessory Logics
    
    var toolbarButtonConstraint: NSLayoutConstraint?
    var isKeyboardToolbarHidden = false {
        didSet {
            if isKeyboardToolbarHidden {
                keyboardAccessory.isHidden = true
            } else {
                keyboardAccessory.isHidden = false
            }
        }
    }
    private func setKeyboardToolbar() {
        postView.addSubview(keyboardAccessory)
        keyboardAccessory.snp.makeConstraints { make in
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    var useSafeAreaLayoutGuide: Bool { true }
    
    private func bindKeyboardHeight() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                let toolbarHeight = self.isKeyboardToolbarHidden ? 0 : self.keyboardAccessory.frame.height
                self.keyboardAccessory.snp.remakeConstraints { make in
                    make.left.right.equalTo(0)
                    let bottom = self.useSafeAreaLayoutGuide ? self.view.safeAreaLayoutGuide.snp.bottom : self.view.snp.bottom
                    make.bottom.equalTo(keyboardVisibleHeight == 0 ? bottom : self.view.snp.bottom).offset(-keyboardVisibleHeight)
                }
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0) {
                    self.commentTableView.contentInset.bottom = (keyboardVisibleHeight == 0 ? toolbarHeight : keyboardVisibleHeight + toolbarHeight - self.view.safeAreaInsets.bottom) + CGFloat.standardTopMargin + 7
                    self.commentTableView.verticalScrollIndicatorInsets.bottom = self.commentTableView.contentInset.bottom
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Binding

extension PostDetailViewController {
    func bindTableView(){
        /// StateManager 상태 바인딩
        StateManager.of.comment.bind(postId: self.post.id, with: commentViewModel.dataList).disposed(by: disposeBag)
        StateManager.of.post.bind(with: self.postRelay).disposed(by: disposeBag)
        
        self.postRelay.bind { [weak self] postArray in
            guard let self = self else { return }
            guard let post = postArray.first else { return }
            self.postView.configure(with: post)
            self.postView.commentTableView.adjustHeaderHeight()
        }.disposed(by: disposeBag)
        
        /// 댓글 데이터 테이블뷰 바인딩
        commentViewModel.dataList
            .observe(on: MainScheduler.instance)
            .bind(to: commentTableView.rx.items(cellIdentifier: CommentCell.reuseIdentifier, cellType: CommentCell.self)) { [weak self] row, comment, cell in
                guard let self = self else { return }
                
                cell.configure(with: comment)
                if row == self.focusedItem?.row {
                    cell.focus()
                }
                
                let authorTapped = cell.authorLabel.rx.tap.map{ return true }
                let profileTapped = cell.profileImage.rx
                    .tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
                    .when(.recognized)
                    .map{ _ in return true }
                
                Observable.of(profileTapped, authorTapped)
                    .merge()
                    .bind { [weak self] _ in
                        let profileVC = ProfileTabViewController(userId: comment.author.id)
                        self?.push(viewController: profileVC)
                    }
                    .disposed(by: cell.disposeBag)
                
                
                cell.likeButton.rx.tap
                    .bind { [weak self] _ in
                        guard let self = self else { return }
                        cell.like()
                        NetworkService.put(endpoint: .commentLike(postId: self.post.id, commentId: comment.id), as: LikeResponse.self)
                            .bind { _, response in
                                cell.like(syncWith: response)
                            }
                            .disposed(by: cell.disposeBag)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.replyButton.rx.tap
                    .bind { [weak self] _ in
                        guard let self = self else { return }
                        self.prepareCommentReply(row: row, comment: comment, cell: cell)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.bubbleView.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
                    .when(.recognized)
                    .bind { [weak self] _ in
                        guard let self = self else { return }
                        self.presentCommentActionSheet(row: row, comment: comment, cell: cell)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.cancelButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .bind { [weak self] _ in
                        guard let self = self else { return }
                        self.isKeyboardToolbarHidden = false
                        self.commentTableView.beginUpdates()
                        cell.cancelEditing()
                        self.commentTableView.endUpdates()
                    }.disposed(by: cell.disposeBag)
                
                cell.updateButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .bind { [weak self] _ in
                        guard let self = self else { return }
                        cell.updateButton.showIndicator()
                        NetworkService.update(endpoint: .commentUpdate(postId: self.post.id, commentId: comment.id, content: cell.bubbleTextView.text))
                            .observe(on: MainScheduler.instance)
                            .bind { request in
                                // workaround
                                var updatedComment = comment
                                updatedComment.content = cell.bubbleTextView.text
                                
                                self.isKeyboardToolbarHidden = false
                                self.commentTableView.beginUpdates()
                                cell.completeEditing()
                                self.commentTableView.endUpdates()
                                self.commentTableView.scrollToRow(at: .init(row: row, section: 0), at: .bottom, animated: true)
                                cell.updateButton.hideIndicator()
                                
                                StateManager.of.comment.dispatch(.init(data: updatedComment, operation: .edit))
                            }
                            .disposed(by: cell.disposeBag)
                    }.disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        /// `isLoading` 값이 바뀔 때마다 상단 스피너를 토글합니다.
        commentViewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.postHeader.showLoadingSpinner()
                } else {
                    self?.postHeader.hideLoadingSpinner()
                }
            })
            .disposed(by: disposeBag)
        
        /// 이전 댓글 보기 버튼은 다음 데이터 유무에 따라 숨겨집니다.
        commentViewModel.hasNextObservable.map({!$0}).bind(to: postHeader.loadButtonHStack.rx.isHidden).disposed(by: disposeBag)
        
        /// 이전 댓글 보기 버튼 바인딩
        postHeader.loadPreviousButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.commentViewModel.loadMore()
            }
            .disposed(by: disposeBag)
        
        /// 댓글 전송 버튼의 활성화 여부를 바인딩합니다.
        keyboardTextView.isEmptyObservable.map({ !$0 }).bind(to: postView.sendButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func bindReply() {
        /// 전송 버튼을 누르면 댓글을 등록합니다.
        postView.sendButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                let focused = self.focusedItem?.comment
                let parentId = focused?.depth == 2 ? focused?.parent : focused?.id  // 대댓글에는 댓글을 달 수 없다.
                
                NetworkService.upload(endpoint: .comment(postId: self.post.id, to: parentId, content: self.keyboardTextView.text))
                    .subscribe(onNext: { data in
                        data.responseDecodable(of: Comment.self) { dataResponse in
                            guard var comment = dataResponse.value else { return }
                            let indexPath = self.commentViewModel.findInsertionIndexPath(of: comment)
                            comment.post_id = self.post.id  // to be deprecated
                            self.post.comments += 1
                            StateManager.of.post.dispatch(self.post, commentCount: self.post.comments)
                            StateManager.of.comment.dispatch(.init(data: comment, operation: .insert(index: indexPath.row)))
                            self.commentTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                            
                        }
                    }, onError: { error in
                        print(error)
                    })
                    .disposed(by: self.disposeBag)
                self.keyboardTextView.text = ""
                self.postView.hideFocusedInfo()
                self.focusedItem = nil
            }
            .disposed(by: disposeBag)
        
        /// 답글 남기기 취소 버튼
        postView.cancelFocusingButton.rx.tapGesture().when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.postView.hideFocusedInfo()
                self.focusedItem = nil
            }
            .disposed(by: disposeBag)
    }
    
    
    private func bindButtons() {
        postView.likeButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.postHeader.like()
                NetworkService.put(endpoint: .newsfeedLike(postId: self.post.id), as: LikeResponse.self)
                    .bind { response in
                        self.postHeader.like(syncWith: response.1)
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        postView.commentButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.keyboardTextView.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        
        postView.shareButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.presentCreatePostVC(sharing: self.post, update: false)
            }
            .disposed(by: disposeBag)
        
        postView.leftChevronButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        
        let authorNameTapped = postView.authorHeaderView.authorNameLabel.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig).when(.recognized)  // not working...
        let profileImageTapped = postView.authorHeaderView.profileImageView.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig).when(.recognized)
        Observable.of(authorNameTapped, profileImageTapped)
            .merge()
            .bind { [weak self] _ in
                guard let self = self else { return }
                let profileVC = ProfileTabViewController(userId: self.post.author?.id)
                self.push(viewController: profileVC)
            }
            .disposed(by: disposeBag)
        
        let sharedAuthorNameTapped = postView.postContentHeaderView.postContentView.sharedPostView.postHeader.authorNameLabel.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig).when(.recognized)  // not working...
        let sharedProfileImageTapped = postView.postContentHeaderView.postContentView.sharedPostView.postHeader.profileImageView.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig).when(.recognized)
        Observable.of(sharedAuthorNameTapped, sharedProfileImageTapped)
            .merge()
            .bind { [weak self] _ in
                guard let self = self else { return }
                let profileVC = ProfileTabViewController(userId: self.post.shared_post?.author.id)
                self.push(viewController: profileVC)
            }
            .disposed(by: disposeBag)
        
        postView.authorHeaderView.ellipsisButton.showsMenuAsPrimaryAction = true
        postView.authorHeaderView.ellipsisButton.menu = getPostMenus(of: post, deleteHandler: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
}

extension PostDetailViewController {
    func prepareCommentReply(row: Int, comment: Comment, cell: CommentCell) {
        self.postView.textView.becomeFirstResponder()
        self.commentTableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .bottom, animated: true)
        self.focusedItem = .init(row: row, comment: comment, cell: cell)
    }
    
    func presentCommentActionSheet(row: Int, comment: Comment, cell: CommentCell) {
        let isMyComment = comment.author.id == StateManager.of.user.profile.id
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "답글 달기",
                                      style: .default) { action in
            self.prepareCommentReply(row: row, comment: comment, cell: cell)
        })
        
        if isMyComment {
            sheet.addAction(UIAlertAction(title: "수정", style: .default, handler: { _ in
                self.focusedItem = nil
                self.isKeyboardToolbarHidden = true
                self.commentTableView.beginUpdates()
                cell.startEditing()
                self.commentTableView.endUpdates()
                self.commentTableView.scrollToRow(at: .init(row: row, section: 0), at: .bottom, animated: true)
            }))
        }
        
        sheet.addAction(UIAlertAction(title: "복사", style: .default) { _ in
            UIPasteboard.general.string = cell.contentLabel.text
        })
        
        if isMyComment {
            sheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                self.focusedItem = nil
                NetworkService.delete(endpoint: .commentDelete(postId: self.post.id, commentId: comment.id))
                    .bind { [weak self] response in
                        guard let self = self else { return }
                        var comment = comment
                        comment.post_id = self.post.id
                        let deleteIndices = self.commentViewModel.findDeletionIndices(of: comment)
                        self.post.comments -= deleteIndices.count
                        StateManager.of.post.dispatch(self.post, commentCount: self.post.comments)
                        StateManager.of.comment.dispatch(delete: comment, at: deleteIndices)
                        if row > 0 {
                            self.commentTableView.scrollToRow(at: .init(row: row - 1, section: 0), at: .bottom, animated: true)
                        }
                    }
                    .disposed(by: self.disposeBag)
            }))
        }
        
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(sheet, animated: true, completion: nil)
    }
}
