//
//  UIViewController+PostCellConfig.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/25.
//

import Foundation
import UIKit
import RxSwift

extension UIViewController {
    
    enum PostMenu: CaseIterable {
        case edit
        case delete
        
        var text: String {
            switch self {
            case .edit:
                return "게시물 수정"
            case .delete:
                return "게시물 삭제"
            }
        }
        
        var symbolName: String {
            switch self {
            case .edit:
                return "square.and.pencil"
            case .delete:
                return "trash"
            }
        }
        
        var symbol: UIImage {
            return UIImage(systemName: symbolName)!
        }
    }
    
    func getPostMenus(of post: Post, deleteHandler: (() -> Void)? = nil) -> UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [
            // EDIT
            UIAction(title: PostMenu.edit.text, image: PostMenu.edit.symbol, handler: { _ in
                self.presentEditPostVC(editing: post)
            }),
            // DELETE
            UIAction(title: PostMenu.delete.text, image: PostMenu.delete.symbol, attributes: .destructive, handler: { _ in
                let alert = UIAlertController(title: "게시물을 삭제하시겠습니까?", message: "이 작업은 되돌릴 수 없습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                    let _ = NetworkService.delete(endpoint: .newsfeed(postId: post.id)).bind(onNext: {_ in})  // single observable: no need to dispose
                    StateManager.of.post.dispatch(.init(data: post, operation: .delete(index: nil)))
                    guard let deleteHandler = deleteHandler else {
                        return
                    }
                    deleteHandler()
                }))
                self.present(alert, animated: true, completion: nil)
            })
        ])
    }
    
    func pushToDetailVC(cell: PostCell<PostContentView>, asFirstResponder: Bool) {
        let detailVC = PostDetailViewController(post: cell.postContentView.post, asFirstResponder: asFirstResponder)
        self.push(viewController: detailVC)
    }
    
    func presentCommentModalVC(to post: Post) {
        let vc = CommentModalViewConroller(post: post, asFirstResponder: true)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isModalInPresentation = true
        self.present(nvc, animated: true, completion: nil)
    }
    
    func presentCreatePostVC(sharing post: Post? = nil, update: Bool = true) {
        let vc = CreatePostViewController(sharing: post, update: update)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true, completion: nil)
    }
    
    func presentEditPostVC(editing post: Post) {
        let vc = EditPostViewController(editing: post)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true, completion: nil)
    }
    
    /// PostCell Configuration Logic
    func configure(cell: PostCell<PostContentView>, with post: Post) {
        cell.configure(with: post)
        
        let ellipsis = cell.postContentView.postHeader.ellipsisButton
        if post.author?.id != StateManager.of.user.profile.id {
            ellipsis.isHidden = true
        } else {
            ellipsis.isHidden = false
            ellipsis.showsMenuAsPrimaryAction = true
            ellipsis.menu = getPostMenus(of: post)
        }
        
        // 좋아요 버튼 바인딩
        cell.postContentView.buttonHorizontalStackView.likeButton.rx.tap.bind { _ in
            cell.postContentView.like()
            NetworkService.put(endpoint: .newsfeedLike(postId: post.id), as: LikeResponse.self)
                .bind { response in
                    cell.postContentView.like(syncWith: response.1)
                }
                .disposed(by: cell.refreshingBag)
        }.disposed(by: cell.refreshingBag)
        
        // 이미지 그리드 터치 제스쳐 등록
        cell.postContentView.imageGridCollectionView.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                let subpostVC = SubPostsViewController(post: cell.postContentView.post)
                self.push(viewController: subpostVC)
            }
            .disposed(by: cell.refreshingBag)
        
        // 공유된 이미지 터치 제스쳐 등록
        cell.postContentView.sharedPostView.imageGridCollectionView.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                if cell.postContentView.sharedPostView.imageGridCollectionView.numberOfImages == 1 {
                    return  // 한 장짜리 이미지는 원래 전체화면 프리뷰로 전환되어야 한다.
                }
                let subpostVC = SubPostsViewController(post: cell.postContentView.sharedPostView.post)
                self.push(viewController: subpostVC)
            }
            .disposed(by: cell.refreshingBag)
        
        // 댓글 버튼 터치 시 디테일 화면으로 이동
        cell.postContentView.buttonHorizontalStackView.commentButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.pushToDetailVC(cell: cell, asFirstResponder: true)
            }.disposed(by: cell.refreshingBag)
        
        cell.postContentView.buttonHorizontalStackView.shareButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.presentCreatePostVC(sharing: cell.postContentView.post)
            }.disposed(by: cell.refreshingBag)
        
        let authorNameTapped = cell.postContentView.postHeader.authorNameLabel.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig).when(.recognized)  // not working...
        let profileImageTapped = cell.postContentView.postHeader.profileImageView.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig).when(.recognized)
        Observable.of(profileImageTapped, authorNameTapped)
            .merge()
            .bind { [weak self] _ in
                let profileVC = ProfileTabViewController(userId: post.author?.id)
                self?.push(viewController: profileVC)
            }
            .disposed(by: cell.refreshingBag)
        
        let sharedAuthorNameTapped = cell.postContentView.sharedPostView.postHeader.authorNameLabel.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig).when(.recognized)  // not working...
        let sharedProfileImageTapped = cell.postContentView.sharedPostView.postHeader.profileImageView.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig).when(.recognized)
        Observable.of(sharedAuthorNameTapped, sharedProfileImageTapped)
            .merge()
            .bind { [weak self] _ in
                let profileVC = ProfileTabViewController(userId: post.shared_post?.author.id)
                self?.push(viewController: profileVC)
            }
            .disposed(by: cell.refreshingBag)
        
        // 댓글 수 클릭시 디테일 화면으로 이동
        cell.postContentView.commentCountButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.pushToDetailVC(cell: cell, asFirstResponder: false)
            }.disposed(by: cell.refreshingBag)
        
        cell.postContentView.postHeader.labelStack.rx
            .tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
            .when(.recognized)
            .bind { [weak self] _ in
                self?.pushToDetailVC(cell: cell, asFirstResponder: false)
            }.disposed(by: cell.refreshingBag)
        
        cell.postContentView.sharedPostView.postHeader.labelStack.rx
            .tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
            .when(.recognized)
            .bind { [weak self] _ in
                let vc = PostDetailViewController(post: cell.postContentView.sharedPostView.post, asFirstResponder: false)
                self?.push(viewController: vc)
            }.disposed(by: cell.refreshingBag)
    }
}

