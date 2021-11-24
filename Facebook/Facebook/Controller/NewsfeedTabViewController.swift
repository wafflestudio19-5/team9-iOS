//
//  NewsfeedTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import RxSwift
import RxGesture

class NewsfeedTabViewController<View: NewsfeedTabView>: BaseViewController {

    override func loadView() { view = View() }
    
    private final var newsfeed: NewsfeedTabView { return view as! View }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
