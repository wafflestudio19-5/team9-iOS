//
//  DatePopOverViewController.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class DatePopOverViewController<View: DatePopOverView>: UIViewController {

    override func loadView() {
        view = View()
    }
    
    var datePopOverView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    var tableView: UITableView {
        datePopOverView.datePopOverTableView
    }
    
    let disposeBag = DisposeBag()
    
    let yearDataBR: BehaviorRelay<[Int]> = BehaviorRelay<[Int]>(value: [])
    let monthDataBR: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"])
    let dayDataBR: BehaviorRelay<[Int]> = BehaviorRelay<[Int]>(value: Array(1...31))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setData()
        bindTableView()
    }


    func setData() {
        let now = Date()
        let calender = Calendar.current
        let currentYear = calender.component(.year, from: now)
        
        yearDataBR.accept(Array(1905...currentYear))
    }
    
    func bindTableView() {
        yearDataBR.bind(to: tableView.rx.items(cellIdentifier: LabelTableViewCell.reuseIdentifier, cellType: LabelTableViewCell.self)) { row, element, cell in
            cell.initialSetup(cellStyle: .style2)
            cell.configureCell(labelText: String(element))
        }
        .disposed(by: disposeBag)
    }

}
