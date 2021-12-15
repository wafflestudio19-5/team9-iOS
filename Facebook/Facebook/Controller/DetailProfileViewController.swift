//
//  DetailProfileViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/14.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class DetailProfileViewController<View: DetailProfileView>: UIViewController {

    override func loadView() {
        view = View()
    }
    
    var detailProfileView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    var tableView: UITableView {
        detailProfileView.detailProfileTableView
    }
    
    let disposeBag = DisposeBag()
    
    let dummyObservable = Observable.just(1...10)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindTableView()
    }
    
    func bindTableView() {
        dummyObservable.bind(to: tableView.rx.items) { (tableView, row, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailProfileCell", for: IndexPath.init(row: row, section: 0))
            return cell
        }.disposed(by: disposeBag)
    }
}
