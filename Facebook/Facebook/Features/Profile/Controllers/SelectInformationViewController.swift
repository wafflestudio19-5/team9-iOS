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
    
    //정보를 담는 셀의 종류(이미지와 레이블, 레이블만)
    enum CellType {
        case withImage
        case withoutImage
    }
    
    //추가하는 정보의 종류
    enum InformationType {
        case company
        case role
        case location
        case university
        case major
    }
    
    var cellType: CellType
    var informationType: InformationType
    var information = ""
    
    let searchResultBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay<[MultipleSectionModel]>(value: [])
    
    //이전 뷰 컨트롤러(AddInformationViewController)로 데이터를 전달하기 위한 PublishSubject 객체
    let selectedInformation: PublishSubject<String> = PublishSubject<String>()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .SimpleInformationItem(style, informationType, image, information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(image: image, information: information)
            
            return cell
        case let .LabelItem(style, labelText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.reuseIdentifier, for: idxPath) as? LabelTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(labelText: labelText)
            
            return cell
        default:
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    init(cellType: CellType, informationType: InformationType, information: String? = nil) {
        self.cellType = cellType
        self.informationType = informationType
        super.init(nibName: nil, bundle: nil)
        
        if let information = information {
            self.selectInformationView.searchHeaderView.searchTextField.text = information
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItem()
        initialSetup()
        bindTableView()
    }
    
    private func setNavigationItem() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initialSetup() {
        switch self.informationType {
        case .university:
            self.title = "대학 선택"
            selectInformationView.searchHeaderView.searchTextField.placeholder = "대학 선택"
        case .company:
            self.title = "직장 선택"
            selectInformationView.searchHeaderView.searchTextField.placeholder = "직장 선택"
        case .role:
            self.title = "직책 선택"
            selectInformationView.searchHeaderView.searchTextField.placeholder = "직책 선택"
        case .location:
            self.title = "위치 선택"
            selectInformationView.searchHeaderView.searchTextField.placeholder = "위치 선택"
        case .major:
            self.title = "전공 선택"
            selectInformationView.searchHeaderView.searchTextField.placeholder = "전공 선택"
        }
    }

    private func bindTableView() {
        //search TextField입력값에 따른 셀 추가
        selectInformationView.searchHeaderView.searchTextField.rx.text.orEmpty.debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                //searchBar 입력값이 없으면 추가 셀을 띄우기 않음
                if text == "" {
                    self.searchResultBR.accept([])
                } else {
                    self.information = text
                    
                    switch self.cellType {
                    case .withImage:
                        var addCellData: SectionItem
                        if self.informationType == .company {
                            addCellData = .SimpleInformationItem(style: .style4,
                                                                 image: UIImage(systemName: "briefcase.circle.fill") ?? UIImage(),
                                                                 information: "\"\(text)\" 추가")
                        } else {
                            addCellData = .SimpleInformationItem(style: .style4,
                                                                 image: UIImage(systemName: "graduationcap.circle.fill") ?? UIImage(),
                                                                 information: "\"\(text)\" 추가")
                        }
                        
                        let searchData: [MultipleSectionModel] = [.DetailInformationSection(title: "검색 결과", items: [addCellData])]
                        self.searchResultBR.accept(searchData)
                    case .withoutImage:
                        let addCellData: SectionItem = .LabelItem(style: .style2, labelText: "\"\(text)\" 추가")
                        let searchData: [MultipleSectionModel] = [.DetailInformationSection(title: "검색 결과", items: [addCellData])]
                        self.searchResultBR.accept(searchData)
                    }
                    
                }
            }).disposed(by: disposeBag)
        
        selectInformationView.searchHeaderView.deleteButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.selectInformationView.searchHeaderView.searchTextField.text = ""
            self.selectedInformation.onNext("")
            self.searchResultBR.accept([])
        }.disposed(by: disposeBag)
        
        searchResultBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        //TableView 셀 선택 시 동작
        tableView.rx.modelSelected(SectionItem.self).subscribe(onNext: { [weak self] item in
            guard let self = self else { return }
            self.selectedInformation.onNext(self.information)
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}

protocol SelectInformationDelegate {
    func didSelectInformation()
}
