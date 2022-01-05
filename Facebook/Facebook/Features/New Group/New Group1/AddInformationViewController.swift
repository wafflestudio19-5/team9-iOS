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

    var defaultSections: [MultipleSectionModel] = []
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay<[MultipleSectionModel]>(value: [])
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .AddInformationWithImageItem(style, image, information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style4)
            cell.configureCell(image: image, information: information)
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                
                var selectInformationViewController: SelectInformationViewController<SelectInformationView>
                switch style {
                case .company:
                    selectInformationViewController = SelectInformationViewController(cellType: .withImage, informationType: style)
                case .university:
                    selectInformationViewController = SelectInformationViewController(cellType: .withImage, informationType: style)
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
                        case .university:
                            self.universityInformation.name = information
                        }
                        
                        self.isActiveSection()
                    }).disposed(by: cell.disposeBag)
                
                self?.push(viewController: selectInformationViewController)
            }).disposed(by: cell.disposeBag)
            
            self.nameBS.subscribe(onNext: { [weak self] name in
                cell.informationLabel.textColor = .black
            }).disposed(by: self.disposeBag)
            
            return cell
        case let .AddInfomrationLabelItem(style, information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.reuseIdentifier, for: idxPath) as? LabelTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style2)
            cell.configureCell(labelText: information)
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                
                var selectInformationViewController: SelectInformationViewController<SelectInformationView>
                switch style {
                case .role:
                    selectInformationViewController = SelectInformationViewController(cellType: .withoutImage, informationType: style)
                case .location:
                    selectInformationViewController = SelectInformationViewController(cellType: .withoutImage, informationType: style)
                case .major:
                    selectInformationViewController = SelectInformationViewController(cellType: .withoutImage, informationType: style)
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
                        case .location:
                            self.companyInformation.location = information
                        case .major:
                            self.universityInformation.major = information
                        default:
                            break
                        }
                        
                        self.isActiveSection()
                    }).disposed(by: cell.disposeBag)
                
                self?.push(viewController: selectInformationViewController)
            }).disposed(by: cell.disposeBag)
            
            switch style {
            case .role:
                self.roleBS.subscribe(onNext: { [weak self] role in
                    cell.label.textColor = .black
                }).disposed(by: self.disposeBag)
            case .location:
                self.locationBS.subscribe(onNext: { [weak self] location in
                    cell.label.textColor = .black
                }).disposed(by: self.disposeBag)
            case .major:
                self.majorBS.subscribe(onNext: { [weak self] major in
                    cell.label.textColor = .black
                }).disposed(by: self.disposeBag)
            default:
                break
            }
            
            return cell
        case let .TextFieldItem(text):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.reuseIdentifier, for: idxPath) as? TextViewTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup()
            cell.configureCell()
            
            return cell
        case let .SelectDateItem(style):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateSelectTableViewCell.reuseIdentifier, for: idxPath) as? DateSelectTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell()
            
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
    
    lazy var companyInformation = Company()
    lazy var universityInformation = University()

    lazy var nameBS = PublishSubject<String>()
    lazy var roleBS = PublishSubject<String>()
    lazy var locationBS = PublishSubject<String>()
    lazy var majorBS = PublishSubject<String>()
    
    var isActive: Bool
    
    
    init(informationType: InformationType, id: Int? = nil) {
        self.informationType = informationType
        self.isActive = true
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
        bindTableView()
    }
    
    private func initialSetup() {
        switch self.informationType {
        case .company:
            self.title = "직장 추가"
            defaultSections = [
                .DetailInformationSection(title: "직장", items: [
                    .AddInformationWithImageItem(style: .company, image: UIImage(systemName: "briefcase")!, information: "직장 추가")
                ])
            ]
        
        case .university:
            self.title = "학력 추가"
            
            defaultSections = [
                .DetailInformationSection(title: "학력", items: [
                    .AddInformationWithImageItem(style: .university, image: UIImage(systemName: "graduationcap")!, information: "학교 이름"),
                    .AddInfomrationLabelItem(style: .major, information: "전공(선택 사항)")
                ]),
                .DetailInformationSection(title: "학력", items: [
                    .SelectDateItem(style: .startDateStyle),
                ])
            ]
        }
        
        sectionsBR.accept(defaultSections)
    }
    
    func loadData() {
        
    }
    
    func createSection() {
        
    }

    private func bindTableView() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    //현재 재직(재학) 중 상태일 때 TableView의 데이터
    private func isActiveSection() {
        var sections: [MultipleSectionModel]
        
        switch self.informationType{
        case .company:
            sections = [
                .DetailInformationSection(title: "직장", items: [
                    .AddInformationWithImageItem(style: .company, image: UIImage(systemName: "briefcase")!, information: companyInformation.name!),
                    .AddInfomrationLabelItem(style: .role,
                                             information: companyInformation.role ?? "직책(선택 사항)"),
                    .AddInfomrationLabelItem(style: .location,
                                             information: companyInformation.location ?? "위치(선택 사항)"),
                    .TextFieldItem(text: "text")
                ]),
                .DetailInformationSection(title: "직장", items: [
                    .SelectDateItem(style: .startDateStyle)
                ])
            ]
        case .university:
            sections = [
                .DetailInformationSection(title: "학력", items: [
                    .AddInformationWithImageItem(style: .university, image: UIImage(systemName: "graduationcap")!, information: universityInformation.name!),
                    .AddInfomrationLabelItem(style: .major,
                                             information: universityInformation.major ?? "전공(선택 사항)")
                ]),
                .DetailInformationSection(title: "학력", items: [
                    .SelectDateItem(style: .startDateStyle),
                ])
            ]
        }
        
        self.sectionsBR.accept(sections)
    }
    
    //현재 재직 중이 아닐 때 TableView의 데이터 
    private func isNotActiveSection() {
        var sections: [MultipleSectionModel]
        
        switch self.informationType{
        case .company:
            sections = [
                .DetailInformationSection(title: "직장", items: [
                    .AddInformationWithImageItem(style: .company, image: UIImage(systemName: "briefcase")!, information: companyInformation.name!),
                    .AddInfomrationLabelItem(style: .role,
                                             information: companyInformation.role ?? "직책(선택 사항)"),
                    .AddInfomrationLabelItem(style: .location,
                                             information: companyInformation.location ?? "위치(선택 사항)"),
                    .TextFieldItem(text: "text")
                ]),
                .DetailInformationSection(title: "직장", items: [
                    .SelectDateItem(style: .startDateStyle),
                    .SelectDateItem(style: .endDateStyle)
                ])
            ]
        case .university:
            sections = [
                .DetailInformationSection(title: "학력", items: [
                    .AddInformationWithImageItem(style: .university, image: UIImage(systemName: "graduationcap")!, information: universityInformation.name!),
                    .AddInfomrationLabelItem(style: .major,
                                             information: universityInformation.major ?? "전공(선택 사항)")
                ]),
                .DetailInformationSection(title: "학력", items: [
                    .SelectDateItem(style: .startDateStyle),
                    .SelectDateItem(style: .endDateStyle)
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
            if self.isActive {
                sectionSwitch.setImage(UIImage(systemName: "square")!, for: .normal)
                self.isNotActiveSection()
                self.isActive = false
            } else {
                sectionSwitch.setImage(UIImage(systemName: "checkmark.square.fill")!, for: .normal)
                self.isActiveSection()
                self.isActive = true
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
