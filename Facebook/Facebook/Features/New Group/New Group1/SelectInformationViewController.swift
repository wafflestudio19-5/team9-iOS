//
//  SelectInformationViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SelectInformationViewController<View: SelectInformationView>: UIViewController {

    override func loadView() {
        view = View()
    }
    
    var selectInformationView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    var tableView: UITableView {
        selectInformationView.selectInformationTableView
    }
    
    let disposeBag = DisposeBag()
    
    let searchResultBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay<[MultipleSectionModel]>(value: [])
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .MainProfileItem(profileImage, coverImage, name):
            let cell = UITableViewCell()
            
            return cell
        case let .ProfileImageItem(image):
            let cell = UITableViewCell()
            
            return cell
        case let .CoverImageItem(image):
            let cell = UITableViewCell()
            
            return cell
        case let .SelfIntroItem(intro):
            let cell = UITableViewCell()
            
            return cell
        case let .DetailInformationItem(image,information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailProfileCell", for: idxPath) as? DetailProfileTableViewCell else { return UITableViewCell() }
            
            cell.informationImage.image = image
            cell.informationLabel.text = information
            
            return cell
        case let .EditProfileItem(title):
            let cell = UITableViewCell()
            
            return cell
        case let .PostItem(post):
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindTableView()
    }

    private func bindTableView() {
//        searchController.searchBar.rx.text.orEmpty.debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .subscribe(onNext: { text in
//                //searchBar 입력값이 없으면 추가 셀을 띄우기 않음
//                if text == "" {
//                    self.searchResultBR.accept([])
//                } else {
//                    let addCellData: SectionItem = .DetailInformationItem(image: UIImage(), information: "\"\(text)\" 추가")
//                    let searchData: [MultipleSectionModel] = [.DetailInformationSection(title: "검색 결과", items: [addCellData])]
//                    self.searchResultBR.accept(searchData)
//                }
//            }).disposed(by: disposeBag)
        
        searchResultBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}
