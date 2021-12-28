//
//  PostViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/05.
//

import UIKit
import RxSwift
import RxCocoa

class PostViewController: UIViewController {
    var post: Post
    let disposeBag = DisposeBag()
    let dummyObservable = Observable.just(1...10)
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PostView()
    }
    
    var postView: PostView {
        guard let view = view as? PostView else { fatalError("PostView가 제대로 초기화되지 않음.") }
        return view
    }
    
    var tableView: UITableView {
        postView.postTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setStyleForNavigationBar()
//        setLayoutForNavigationBar()
        
        bindTableView()
    }

    // Post의 writer프로필 이미지와 이름, 작성 시간에 대한 정보를 navigationBar에 추가
//    func setStyleForNavigationBar() {
//        writerImage.contentMode = .scaleAspectFit
//        let image = UIImage(systemName: "person.circle.fill")
//        writerImage.image = image
//
//        writeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        writeLabel.text = "writer"
//
//        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        timeLabel.textColor = .darkGray
//        timeLabel.text = "17시간 전"
//    }
//
//    func setLayoutForNavigationBar() {
//        titleView.addSubview(writerImage)
//        titleView.addSubview(writeLabel)
//        titleView.addSubview(timeLabel)
//
//        writerImage.translatesAutoresizingMaskIntoConstraints = false
//        writeLabel.translatesAutoresizingMaskIntoConstraints = false
//        timeLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            writerImage.heightAnchor.constraint(equalToConstant: 50),
//            writerImage.widthAnchor.constraint(equalToConstant: 50),
//            writerImage.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 5),
//            writerImage.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 5),
//            writerImage.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10),
//            writeLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 5),
//            writeLabel.leadingAnchor.constraint(equalTo: writerImage.trailingAnchor, constant: 10),
//            timeLabel.topAnchor.constraint(equalTo: writeLabel.bottomAnchor, constant: 3),
//            timeLabel.leadingAnchor.constraint(equalTo: writerImage.trailingAnchor, constant: 10)
//        ])
//
//        navigationItem.titleView = titleView
//    }
    
    func bindTableView(){
        dummyObservable.bind(to: tableView.rx.items) { (tableView, row, item) -> UITableViewCell in
            if row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostContentCell", for: IndexPath.init(row: row, section: 0)) as? PostContentTableViewCell else { return UITableViewCell() }
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: IndexPath.init(row: row - 1, section: 1)) as? CommentTableViewCell else { return UITableViewCell() }
                
                return cell
            }
        }.disposed(by: disposeBag)
    }
}

