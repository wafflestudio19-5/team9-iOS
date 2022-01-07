//
//  AddInformationViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxKeyboard
import MapKit

class AddInformationViewController<View: AddInformationView>: UIViewController, UITableViewDelegate {

    override func loadView() {
        view = View()
    }
    
    var addInformationView: View {
        guard let view = view as? View else { return View() }
        return view
    }

    var tableView: UITableView {
        addInformationView.addInformationTableView
    }
    
    let disposeBag = DisposeBag()
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay<[MultipleSectionModel]>(value: [])
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .AddInformationWithImageItem(style, image, information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style4)
            cell.configureCell(image: image, information: information)
            
            //값의 입력된 정보라면 textColor를 black으로
            switch style {
            case .company:
                if self.companyInformation.name != nil {
                    cell.informationLabel.textColor = .black
                    cell.deleteButton.isHidden = false
                }
            case .university:
                if self.universityInformation.name != nil {
                    cell.informationLabel.textColor = .black
                    cell.deleteButton.isHidden = false
                }
            default:
                break
            }
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                
                var selectInformationViewController: SelectInformationViewController<SelectInformationView>
                switch style {
                case .company:
                    selectInformationViewController = SelectInformationViewController(cellType: .withImage, informationType: style, information: information)
                case .university:
                    selectInformationViewController = SelectInformationViewController(cellType: .withImage, informationType: style, information: information)
                default:
                    selectInformationViewController = SelectInformationViewController(cellType: .withImage, informationType: style)
                }
                
                //SelectInformationViewContoller로 부터 데이터를 받음
                selectInformationViewController.selectedInformation
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] information in
                        guard let self = self else { return }
                        
                        switch self.informationType {
                        case .company:
                            self.companyInformation.name = information
                            if self.companyInformation.is_active == nil {
                                self.companyInformation.is_active = true
                            }
                        case .university:
                            self.universityInformation.name = information
                            if self.universityInformation.is_active == nil {
                                self.universityInformation.is_active = true
                            }
                        }
                        self.createActiveSection()
                    }).disposed(by: cell.disposeBag)
                
                self?.push(viewController: selectInformationViewController)
            }).disposed(by: cell.disposeBag)
            
            cell.deleteButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                switch style {
                case .company:
                    self.companyInformation = Company()
                    self.createDefaultSection()
                case .university:
                    self.universityInformation = University()
                    self.createDefaultSection()
                default:
                    break
                }
                
            }.disposed(by: cell.disposeBag)
            
            return cell
        case let .AddInfomrationLabelItem(style, information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.reuseIdentifier, for: idxPath) as? LabelTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style2)
            cell.configureCell(labelText: information)
            
            //값의 입력된 정보라면 textColor를 black으로
            switch style {
            case .role:
                if self.companyInformation.role != nil {
                    cell.label.textColor = .black
                }
            case .location:
                if self.companyInformation.location != nil {
                    cell.label.textColor = .black
                }
            case .major:
                if self.universityInformation.major != nil {
                    cell.label.textColor = .black
                }
            default:
                break
            }
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                
                var selectInformationViewController: SelectInformationViewController<SelectInformationView>
                switch style {
                case .role:
                    selectInformationViewController =  SelectInformationViewController(cellType: .withoutImage, informationType: style, information: information)
                case .location:
                    selectInformationViewController = SelectInformationViewController(cellType: .withoutImage, informationType: style, information: information)
                case .major:
                    selectInformationViewController = SelectInformationViewController(cellType: .withoutImage, informationType: style, information: information)
                default:
                    selectInformationViewController = SelectInformationViewController(cellType: .withoutImage, informationType: style)
                }
                
                //SelectInformationViewContoller로 부터 데이터를 받음
                selectInformationViewController.selectedInformation
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] information in
                        guard let self = self else { return }
                        
                        switch style {
                        case .role:
                            self.companyInformation.role = information
                            (self.companyInformation.is_active ?? true) ?
                                self.createActiveSection() : self.createNotActiveSection()
                        case .location:
                            self.companyInformation.location = information
                            (self.companyInformation.is_active ?? true) ?
                                self.createActiveSection() : self.createNotActiveSection()
                        case .major:
                            self.universityInformation.major = information
                            (self.universityInformation.is_active ?? true) ?
                                self.createActiveSection() : self.createNotActiveSection()
                        default:
                            break
                        }
                    }).disposed(by: cell.disposeBag)
                
                self?.push(viewController: selectInformationViewController)
            }).disposed(by: cell.disposeBag)
            
            return cell
        case let .TextFieldItem(text):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.reuseIdentifier, for: idxPath) as? TextViewTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup()
            cell.configureCell()
            
            cell.textView.rx.text
                .orEmpty
                .subscribe(onNext: { [weak self] detail in
                    self?.companyInformation.detail = detail
                }).disposed(by: cell.disposeBag)
            
            return cell
        case let .SelectDateItem(style, birthInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateSelectTableViewCell.reuseIdentifier, for: idxPath) as? DateSelectTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(birthInfo: birthInfo)
            
            cell.dateBS.subscribe(onNext: { [weak self] date in
                guard let self = self else { return }
                switch self.informationType {
                case .company:
                    switch style {
                    case .startDateStyle:
                        self.companyInformation.join_date = date
                    case .endDateStyle:
                        self.companyInformation.leave_date = date
                    }
                case .university:
                    switch style {
                    case .startDateStyle:
                        self.universityInformation.join_date = date
                    case .endDateStyle:
                        self.universityInformation.graduate_date = date
                    }
                }
            }).disposed(by: cell.disposeBag)
            
            return cell
        default:
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    enum InformationType {
        case company
        case university
    }
    
    var informationType: InformationType
    var id: Int?
    
    lazy var companyInformation = Company()
    lazy var universityInformation = University()
    
    init(informationType: InformationType, id: Int? = nil) {
        self.informationType = informationType
        super.init(nibName: nil, bundle: nil)
    
        if let id = id {
            self.id = id
            self.loadData(id: id)
        } else {
            self.createDefaultSection()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    func loadData(id: Int) {
        switch informationType {
        case .company:
            NetworkService.get(endpoint: .company(id: id), as: Company.self)
                .subscribe { [weak self] event in
                    guard let self = self else { return }
                
                    if event.isCompleted {
                        return
                    }
                
                    guard let response = event.element?.1 else {
                        print("데이터 로드 중 오류 발생")
                        print(event)
                        return
                    }
                
                    self.companyInformation = response
                    
                    if self.companyInformation.is_active! {
                        self.createActiveSection()
                    } else {
                        self.createNotActiveSection()
                    }
            }.disposed(by: disposeBag)
        case .university:
            NetworkService.get(endpoint: .university(id: id), as: University.self)
                .subscribe { [weak self] event in
                    guard let self = self else { return }
                
                    if event.isCompleted {
                        return
                    }
                
                    guard let response = event.element?.1 else {
                        print("데이터 로드 중 오류 발생")
                        print(event)
                        return
                    }
        
                    self.universityInformation = response
                    
                    if self.universityInformation.is_active! {
                        self.createActiveSection()
                    } else {
                        self.createNotActiveSection()
                    }
            }.disposed(by: disposeBag)
        }
    }

    private func bind() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        addInformationView.saveButton.rx.tap.bind{ [weak self] in
            guard let self = self else { return }
            switch self.informationType {
            case .company:
                print(self.companyInformation)
            case .university:
                print(self.universityInformation)
            }
            
            self.saveData()
        }.disposed(by: disposeBag)
    }
    
    private func saveData() {
        if let id = self.id {
            switch self.informationType {
            case .company:
                if self.companyInformation.name == "" {
                    NetworkService.delete(endpoint: .company(id: id)).subscribe(onNext: { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    }).disposed(by: self.disposeBag)
                } else {
                    NetworkService.put(endpoint: .company(id: id, company: self.companyInformation), as: Company.self).subscribe(onNext: { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    }).disposed(by: self.disposeBag)
                }
            case .university:
                if self.universityInformation.name == "" {
                    NetworkService.delete(endpoint: .university(id: id)).subscribe(onNext: { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    }).disposed(by: self.disposeBag)
                } else {
                    NetworkService.put(endpoint: .university(id: id, university: self.universityInformation), as: University.self).subscribe(onNext: { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    }).disposed(by: self.disposeBag)
                }
            }
        } else {
            switch self.informationType {
            case .company:
                NetworkService.post(endpoint: .company(company: self.companyInformation), as: Company.self).subscribe(onNext: { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }).disposed(by: self.disposeBag)
            case .university:
                NetworkService.post(endpoint: .university(university: self.universityInformation), as: University.self).subscribe(onNext: { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }).disposed(by: self.disposeBag)
            }
        }
    }
    
    private func createDefaultSection() {
        var sections: [MultipleSectionModel]
        
        switch self.informationType {
        case .company:
            self.title = "직장 추가"
            sections = [
                .DetailInformationSection(title: "직장", items: [
                    .AddInformationWithImageItem(style: .company,
                                                 image: UIImage(systemName: "briefcase.circle.fill") ?? UIImage(),
                                                 information: "직장 추가")
                ])
            ]
        
        case .university:
            self.title = "학력 추가"
            
            sections = [
                .DetailInformationSection(title: "학력", items: [
                    .AddInformationWithImageItem(style: .university,
                                                 image: UIImage(systemName: "graduationcap.circle.fill") ?? UIImage(),
                                                 information: "학교 이름"),
                    .AddInfomrationLabelItem(style: .major, information: "전공(선택 사항)")
                ]),
                .DetailInformationSection(title: "학력", items: [
                    .SelectDateItem(style: .startDateStyle,
                                    birthInfo: universityInformation.join_date ?? ""),
                ])
            ]
        }
        
        sectionsBR.accept(sections)
    }
    
    //현재 재직(재학) 중 상태일 때 TableView의 데이터
    private func createActiveSection() {
        var sections: [MultipleSectionModel]
        
        switch self.informationType{
        case .company:
            sections = [
                .DetailInformationSection(title: "직장", items: [
                    .AddInformationWithImageItem(style: .company,
                                                 image: UIImage(systemName: "briefcase") ?? UIImage(),
                                                 information:  (companyInformation.name != nil && companyInformation.name != "") ? companyInformation.name! : "직장 추가"),
                    .AddInfomrationLabelItem(style: .role,
                                             information: (companyInformation.role != nil && companyInformation.role != "") ? companyInformation.role! : "직책(선택 사항)"),
                    .AddInfomrationLabelItem(style: .location,
                                             information: (companyInformation.location != nil && companyInformation.location != "") ? companyInformation.location! : "위치(선택 사항)"),
                    .TextFieldItem(text: "text")
                ]),
                .DetailInformationSection(title: "직장", items: [
                    .SelectDateItem(style: .startDateStyle,
                                    birthInfo: companyInformation.join_date ?? "")
                ])
            ]
        case .university:
            sections = [
                .DetailInformationSection(title: "학력", items: [
                    .AddInformationWithImageItem(style: .university,
                                                 image: UIImage(systemName: "graduationcap") ?? UIImage(),
                                                 information: (universityInformation.name != nil && universityInformation.name != "") ? universityInformation.name! : "학교 이름"),
                    .AddInfomrationLabelItem(style: .major,
                                             information: (universityInformation.major != nil && universityInformation.major != "") ? universityInformation.major! : "전공(선택 사항)")
                ]),
                .DetailInformationSection(title: "학력", items: [
                    .SelectDateItem(style: .startDateStyle,
                                    birthInfo: universityInformation.join_date ?? ""),
                ])
            ]
        }
        
        self.sectionsBR.accept(sections)
    }
    
    //현재 재직 중이 아닐 때 TableView의 데이터
    private func createNotActiveSection() {
        var sections: [MultipleSectionModel]
        
        switch self.informationType{
        case .company:
            sections = [
                .DetailInformationSection(title: "직장", items: [
                    .AddInformationWithImageItem(style: .company,
                                                 image: UIImage(systemName: "briefcase") ?? UIImage(),
                                                 information: (companyInformation.name != nil && companyInformation.name != "") ? companyInformation.name! : "직장 추가"),
                    .AddInfomrationLabelItem(style: .role,
                                             information: (companyInformation.role != nil && companyInformation.role != "") ? companyInformation.role! : "직책(선택 사항)"),
                    .AddInfomrationLabelItem(style: .location,
                                             information: (companyInformation.location != nil && companyInformation.location != "") ? companyInformation.location! : "위치(선택 사항)"),
                    .TextFieldItem(text: "text")
                ]),
                .DetailInformationSection(title: "직장", items: [
                    .SelectDateItem(style: .startDateStyle,
                                    birthInfo: companyInformation.join_date ?? ""),
                    .SelectDateItem(style: .endDateStyle,
                                    birthInfo: companyInformation.leave_date ?? "")
                ])
            ]
        case .university:
            sections = [
                .DetailInformationSection(title: "학력", items: [
                    .AddInformationWithImageItem(style: .university,
                                                 image: UIImage(systemName: "graduationcap") ?? UIImage(),
                                                 information: (universityInformation.name != nil && universityInformation.name != "") ? universityInformation.name! : "학교 이름"),
                    .AddInfomrationLabelItem(style: .major,
                                             information: (universityInformation.major != nil && universityInformation.major != "") ? universityInformation.major! : "전공(선택 사항)")
                ]),
                .DetailInformationSection(title: "학력", items: [
                    .SelectDateItem(style: .startDateStyle,
                                    birthInfo: universityInformation.join_date ?? ""),
                    .SelectDateItem(style: .endDateStyle,
                                    birthInfo: universityInformation.graduate_date ?? "")
                ])
            ]
        }
        
        self.sectionsBR.accept(sections)
    }
    
    //UITableView의 custom header적용
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if section == 0 { return UIView() }
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 42)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .white
        
        let sectionLabel = UILabel(frame: frame)
        sectionLabel.text = "현재 재직 중"
        sectionLabel.textColor = .black
        sectionLabel.font = UIFont.systemFont(ofSize: 18)
        
        let sectionSwitch = UIButton()
        //sectionSwitch.onTintColor = .systemBlue
        sectionSwitch.setImage(UIImage(systemName: "checkmark.square.fill")!, for: .normal)
        sectionSwitch.tintColor = .systemBlue
        
        headerView.addSubview(sectionLabel)
        headerView.addSubview(sectionSwitch)
        
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            sectionSwitch.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            sectionSwitch.heightAnchor.constraint(equalToConstant: 30),
            sectionSwitch.widthAnchor.constraint(equalToConstant: 30),
            sectionSwitch.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -15)
        ])
        
        sectionSwitch.rx.tap.bind { [weak self]  in
            guard let self = self else { return }
            switch self.informationType {
            case .company:
                if self.companyInformation.is_active! {
                    sectionSwitch.setImage(UIImage(systemName: "square")!, for: .normal)
                    sectionSwitch.tintColor = .gray
                    self.companyInformation.is_active = false
                    self.createNotActiveSection()
                } else {
                    sectionSwitch.setImage(UIImage(systemName: "checkmark.square.fill")!, for: .normal)
                    sectionSwitch.tintColor = .systemBlue
                    self.companyInformation.is_active = true
                    self.createActiveSection()
                }
            case .university:
                if self.universityInformation.is_active! {
                    sectionSwitch.setImage(UIImage(systemName: "square")!, for: .normal)
                    sectionSwitch.tintColor = .gray
                    self.universityInformation.is_active = false
                    self.createNotActiveSection()
                } else {
                    sectionSwitch.setImage(UIImage(systemName: "checkmark.square.fill")!, for: .normal)
                    sectionSwitch.tintColor = .systemBlue
                    self.universityInformation.is_active = true
                    self.createActiveSection()
                }
            }
        }.disposed(by: disposeBag)
    
        return headerView
    }
    
    //footer의 separate line
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .systemGray6
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 } //마지막 section header 제거
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
