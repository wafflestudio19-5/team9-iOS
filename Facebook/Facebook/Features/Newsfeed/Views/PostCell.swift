//
//  PostCell.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/18.
//

import UIKit
import SwiftUI
import RxSwift

class PostCell<ContentView: PostContentView>: UITableViewCell {
    /// cell이 reuse될 때 `refreshingBag`은 새로운 것으로 갈아끼워진다. 따라서 기존 cell의 구독이 취소된다.
    var refreshingBag = DisposeBag()
    class var reuseIdentifier: String { "PostCell" }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.width = UIScreen.main.bounds.width  // important for initial layout
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.refreshingBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use storyboard. Load programmatically.")
    }
    
    func configure(with newPost: Post, showGrid: Bool = true) {
        postContentView.configure(with: newPost, showGrid: showGrid)
        self.layoutIfNeeded()
    }
    
    func setLayout() {
        contentView.addSubview(postContentView)
        postContentView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    let postContentView = ContentView()
}

/*
 MARK: SwiftUI Preview
 */

struct PostCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = PostCell().contentView
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct PostCellPreview: PreviewProvider {
    static var previews: some View {
        VStack{
            Spacer()
            PostCellRepresentable()
            Spacer()
        }.background(.white)
    }
}
