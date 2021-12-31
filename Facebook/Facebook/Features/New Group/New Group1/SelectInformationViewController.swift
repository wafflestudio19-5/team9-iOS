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
        case let .SimpleInformationItem(style, image,information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(image: image, information: information)
            
            return cell
        default:
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    var inforomationType: String = ""
    var information = ""
    let selectedInformation: PublishSubject<SectionItem> = PublishSubject<SectionItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "\(inforomationType) 선택"
        selectInformationView.searchHeaderView.searchTextField.placeholder = "\(inforomationType) 선택"
        bindTableView()
    }

    private func bindTableView() {
        //search TextField입력값에 따른 셀 추가
        selectInformationView.searchHeaderView.searchTextField.rx.text.orEmpty.debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                //searchBar 입력값이 없으면 추가 셀을 띄우기 않음
                if text == "" {
                    self.searchResultBR.accept([])
                } else {
                    self.information = text
                    let addCellData: SectionItem = .SimpleInformationItem(style: .style4, image: UIImage(), information: "\"\(text)\" 추가")
                    let searchData: [MultipleSectionModel] = [.DetailInformationSection(title: "검색 결과", items: [addCellData])]
                    self.searchResultBR.accept(searchData)
                }
            }).disposed(by: disposeBag)
        
        searchResultBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SectionItem.self).subscribe(onNext: { [weak self] item in
            self?.selectedInformation.onNext(item)
            self?.navigationController?.popViewController(animated: true)
        })
    }
}

protocol SelectInformationDelegate {
    func didSelectInformation()
}
