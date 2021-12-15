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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailProfileCell", for: IndexPath.init(row: row, section: 0)) as? DetailProfileTableViewCell else { return UITableViewCell() }
            
            cell.informationImage.layer.cornerRadius = cell.informationImage.frame.width / 2
            cell.informationImage.clipsToBounds = true
            
            cell.informationImage.backgroundColor = .systemGray4
            cell.informationImage.tintColor = .lightGray
            cell.informationLabel.textColor = .systemBlue
            
            return cell
        }.disposed(by: disposeBag)
    }
}
