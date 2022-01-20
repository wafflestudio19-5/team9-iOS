//
//  CommentPaginationViewModel.swift
//  Facebook
//
//  Created by 박신홍 on 2022/01/06.
//

import UIKit

class CommentPaginationViewModel: PaginationViewModel<Comment> {
    
    /// Flatten nested comment data via preorder traversal.
    private func recursivelyFlatten(comments: [Comment]) -> [Comment] {
        var flatten: [Comment] = []
        
        func preorderTraversal(root: Comment) {
            flatten.append(root)
            for child in root.children ?? [] {
                preorderTraversal(root: child)
            }
        }
        
        for comment in comments {
            preorderTraversal(root: comment)
        }
        return flatten
    }
    
    override func preprocessBeforeAccept(oldData: [Comment] = [], results: [Comment]) -> [Comment] {
        return recursivelyFlatten(comments: results) + oldData
    }
    
    func invalidateLikeState(of comment: Comment, with response: LikeResponse) {
        var comments = dataList.value
        if let firstIndex = comments.firstIndex(where: {$0.id == comment.id}) {
            var target = comments[firstIndex]
            target.is_liked = response.is_liked
            target.likes = response.likes
            comments[firstIndex] = target
        }
        dataList.accept(comments)
    }
    
    /// 업로드된 댓글이 어디에 삽입되어야 하는지 계산한다.
    func findInsertionIndexPath(of comment: Comment) -> IndexPath {
        let flattenComments = dataList.value
        
        // 방금 단 댓글이 최상위 댓글이면 맨 마지막에 삽입한다.
        if comment.depth == 0 {
            return IndexPath(row: flattenComments.count, section: 0)
        }
        
        // parent를 찾고, parent의 다음 sibling을 찾은 뒤 그 직전 인덱스를 반환한다.
        // sibling이 아니라 depth가 한 단계 더 낮은 parent를 찾더라도 그 직전 인덱스를 반환한다.
        var parent: Comment?
        for (row, oldComment) in flattenComments.enumerated() {
            if oldComment.id == comment.parent {  // parent found
                parent = oldComment
                continue
                
            }
            guard let parent = parent else { continue }  // continue until parent is found
            if oldComment.depth <= parent.depth {  // parent's sibling (or parent) is found
                return IndexPath(row: row, section: 0)
            }
        }
        
        // 끝까지 다 봤는데 sibling을 발견하지 못한 경우: 맨 마지막으로
        return IndexPath(row: flattenComments.count, section: 0)
    }
    
    func insert(_ comment: Comment, at indexPath: IndexPath) {
        var newData = dataList.value
        newData.insert(comment, at: indexPath.row)
        dataList.accept(newData)
    }
}
