//
//  NewsfeedTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import Alamofire
import RxSwift
import RxAlamofire

class NewsfeedTabViewController: BaseTabViewController<NewsfeedTabView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = NetworkService.get(endpoint: .pingWithQuery(query: "test"))
            .observe(on: MainScheduler.instance)
            .subscribe { print($0) }
    }
}

