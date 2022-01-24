//
//  AddInformationViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/23.
//

import UIKit
import RxSwift
import RxGesture
import RxCocoa
import RxKeyboard
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
            
            //입력된 정보라면 textColor를 black으로
            switch style {
            case .company:
                if (self.companyInformation.name != nil && self.companyInformation.name != "") {
                    cell.informationLabel.textColor = .black
                    cell.deleteButton.isHidden = false
                }
            case .university:
                if (self.universityInformation.name != nil && self.universityInformation.name != "") {
                    cell.informationLabel.textColor = .black
                    cell.deleteButton.isHidden = false
                }
            default:
                break
            }
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                var selectInformationViewController: SelectInformationViewController<SelectInformationView>
                switch style {
                case .company:
                    selectInformationViewController = SelectInformationViewController(cellType: .withImage, informationType: style, information: self.companyInformation.name ?? "")
                case .university:
                    selectInformationViewController = SelectInformationViewController(cellType: .withImage, informationType: style, information: self.universityInformation.name ?? "")
                default:
                    selectInformationViewController = SelectInformationViewController(cellType: .withImage, informationType: style)
                }
                
                //SelectInformationViewContoller로 부터 데이터를 받음
                selectInformationViewController.selectedInformation
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] information in
                        guard let self = self else { return }
                        
                        self.name.accept(information)
                        
                        switch self.informationType {
                        case .company:
                            self.companyInformation.name = information
                            if self.companyInformation.is_active == nil {
                                self.companyInformation.is_active = true
                                self.createActiveSection()
                            } else {
                                (self.companyInformation.is_active ?? true) ?
                                    self.createActiveSection() : self.createNotActiveSection()
                            }
                        case .university:
                            self.universityInformation.name = information
                            if self.universityInformation.is_active == nil {
                                self.universityInformation.is_active = true
                                self.createActiveSection()
                            } else {
                                (self.universityInformation.is_active ?? true) ?
                                    self.createActiveSection() : self.createNotActiveSection()
                            }
                        }
                    }).disposed(by: cell.disposeBag)
                
                self.push(viewController: selectInformationViewController)
            }).disposed(by: cell.disposeBag)
            
            cell.deleteButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                
                self.name.accept("")
                
                switch self.informationType {
                case .company:
                    self.companyInformation.name = nil
                    if self.companyInformation.is_active == true {
                        self.createActiveSection()
                    } else {
                        self.createNotActiveSection()
                    }
                case .university:
                    self.universityInformation.name = nil
                    if self.universityInformation.is_active == true {
                        self.createActiveSection()
                    } else {
                        self.createNotActiveSection()
                    }
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
                if (self.companyInformation.role != nil && self.companyInformation.role != "") {
                    cell.label.textColor = .black
                }
            case .location:
                if (self.companyInformation.location != nil && self.companyInformation.location != "") {
                    cell.label.textColor = .black
                }
            case .major:
                if (self.universityInformation.major != nil && self.universityInformation.major != ""){
                    cell.label.textColor = .black
                }
            default:
                break
            }
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                var selectInformationViewController: SelectInformationViewController<SelectInformationView>
                switch style {
                case .role:
                    selectInformationViewController =  SelectInformationViewController(cellType: .withoutImage, informationType: style, information: self.companyInformation.role ?? "" )
                case .location:
                    selectInformationViewController = SelectInformationViewController(cellType: .withoutImage, informationType: style, information: self.companyInformation.location ?? "" )
                case .major:
                    selectInformationViewController = SelectInformationViewController(cellType: .withoutImage, informationType: style, information: self.universityInformation.major ?? "" )
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
                
                self.push(viewController: selectInformationViewController)
            }).disposed(by: cell.disposeBag)
            
            return cell
        case let .TextFieldItem(text):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.reuseIdentifier, for: idxPath) as? TextViewTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup()
            cell.configureCell(text: text)
            
            cell.textView.rx.text
                .orEmpty
                .subscribe(onNext: { [weak self] detail in
                    //기본 placeholder 일때는 반영 x 
                    if detail == "직업에 대해 설명해주세요(선택 사항)" { return }
                    self?.companyInformation.detail = detail
                }).disposed(by: cell.disposeBag)
            
            // view의 아무 곳이나 누르면 textView 입력 상태 종료
            self.view.rx.tapGesture(configuration: { _, delegate in
                delegate.touchReceptionPolicy = .custom { _, shouldReceive in
                    return !(shouldReceive.view is UIControl)
                }
            }).bind { [weak self] _ in
                guard let self = self else { return }
                cell.textView.endEditing(true)
            }.disposed(by: self.disposeBag)
            
            return cell
        case let .SelectDateItem(style, dateInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateSelectTableViewCell.reuseIdentifier, for: idxPath) as? DateSelectTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            
            cell.datePS.subscribe(onNext: { [weak self] date in
                guard let self = self else { return }
                
                switch style {
                case .startDateStyle:
                    self.start_date.accept(date)
                case .endDateStyle:
                    self.end_date.accept(date)
                }
                
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
            
            cell.configureCell(dateInfo: dateInfo)
            
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
    
    private let name = BehaviorRelay<String>(value: "")
    private let start_date = BehaviorRelay<String>(value: "")
    private let end_date = BehaviorRelay<String>(value: "")
    private let isActive = BehaviorRelay<Bool>(value: true)
    
    
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
        setNavigationItem()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
                    
                    self.checkHasEntered()
                    
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
                    
                    self.checkHasEntered()
                    
                    if self.universityInformation.is_active! {
                        self.createActiveSection()
                    } else {
                        self.createNotActiveSection()
                    }
            }.disposed(by: disposeBag)
        }
    }
    
    private func setNavigationItem() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backAction() {
        if self.id != nil {
            self.backAlert()
        } else {
            if self.name.value != "" {
                self.backAlert()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func bind() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        addInformationView.saveButton.rx.tap.bind{ [weak self] in
            guard let self = self else { return }
            if self.name.value == "" {
                self.deleteAlert()
            } else {
                self.saveData()
            }
        }.disposed(by: disposeBag)
        
        //저장 버튼 활성화 구현
        let hasEnteredBoth = Observable.combineLatest(name, start_date, isActive, resultSelector: { (!$0.isEmpty && !$1.isEmpty && $2 ) })
        let hasEnteredAll = Observable.combineLatest(name, start_date, end_date, isActive,resultSelector: { !$0.isEmpty && !$1.isEmpty && !$2.isEmpty && !$3 })
        let isEnableButton: Observable<Bool>
        
        if self.id == nil {
            isEnableButton = Observable.combineLatest(hasEnteredBoth, hasEnteredAll, resultSelector: { $0 || $1 })
            
            isEnableButton
                .bind(to: self.addInformationView.saveButton.rx.isEnabled)
                .disposed(by: disposeBag)
        } else {
            isEnableButton = Observable.combineLatest(hasEnteredBoth, hasEnteredAll, name,resultSelector: { $0 || $1 || $2.isEmpty })
        }
        
        isEnableButton
            .bind(to: self.addInformationView.saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isEnableButton
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.addInformationView.saveButton.setTitleColor((result ? .white : .gray), for: .normal)
                self.addInformationView.saveButton.backgroundColor = (result ? .systemBlue : .systemGray4)
            }).disposed(by: disposeBag)
        
        // Keyboard의 높이에 따라 "새 계정 만들기" 버튼 위치 조정
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }

                self.addInformationView.footerView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardVisibleHeight + (keyboardVisibleHeight == 0 ? 0 : 85 ))
                }
                
                self.addInformationView.layoutIfNeeded()
            }).disposed(by: disposeBag)
        
        if informationType == .company {
            sectionSwitch.rx
                .controlEvent(.valueChanged)
                .withLatestFrom(sectionSwitch.rx.value)
                .subscribe(onNext : { [weak self] isOn in
                    guard let self = self else { return }
                    self.companyInformation.is_active = isOn
                    isOn ? self.createActiveSection() : self.createNotActiveSection()
                })
                .disposed(by: disposeBag)
        } else {
            sectionButton.rx
                .tap
                .bind { [weak self]  in
                    guard let self = self else { return }
                    if self.universityInformation.is_active ?? true {
                        self.sectionButton.setImage(UIImage(systemName: "checkmark.square.fill")!, for: .normal)
                        self.sectionButton.tintColor = .systemBlue
                        self.universityInformation.is_active = false
                        self.createNotActiveSection()
                    } else {
                        self.sectionButton.setImage(UIImage(systemName: "square")!, for: .normal)
                        self.sectionButton.tintColor = .gray
                        self.universityInformation.is_active = true
                        self.createActiveSection()
                    }
                }.disposed(by: disposeBag)
        }
    
    }
    
    private func saveData() {
        if let id = self.id {
            switch self.informationType {
            case .company:
                if (self.companyInformation.name == nil || self.companyInformation.name == "")  {
                    NetworkService.delete(endpoint: .company(id: id)).subscribe(onNext: { [weak self] event in
                        guard let self = self else { return }
                        StateManager.of.user.dispatch(companyId: id)
                        self.navigationController?.popViewController(animated: true)
                    }).disposed(by: self.disposeBag)
                } else {
                    NetworkService.put(endpoint: .company(id: id, company: self.companyInformation), as: Company.self).subscribe(onNext: { [weak self] event in
                        guard let self = self else { return }
                        
                        let response = event.1
                        
                        StateManager.of.user.dispatch(companyId: id, company: response)
                        self.navigationController?.popViewController(animated: true)
                    }).disposed(by: self.disposeBag)
                }
            case .university:
                if (self.universityInformation.name == nil || self.universityInformation.name == "") {
                    NetworkService.delete(endpoint: .university(id: id)).subscribe(onNext: { [weak self] event in
                        guard let self = self else { return }
                        StateManager.of.user.dispatch(universityId: id)
                        self.navigationController?.popViewController(animated: true)
                    }).disposed(by: self.disposeBag)
                } else {
                    NetworkService.put(endpoint: .university(id: id, university: self.universityInformation), as: University.self).subscribe(onNext: { [weak self] event in
                        guard let self = self else { return }
                        
                        let response = event.1
                        
                        StateManager.of.user.dispatch(universityId: id, university: response)
                        self.navigationController?.popViewController(animated: true)
                    }).disposed(by: self.disposeBag)
                }
            }
        } else {
            switch self.informationType {
            case .company:
                NetworkService.post(endpoint: .company(company: self.companyInformation), as: Company.self).subscribe(onNext: { [weak self] event in
                    guard let self = self else { return }
                    
                    let response = event.1
                    
                    StateManager.of.user.dispatch(company: response)
                    self.navigationController?.popViewController(animated: true)
                }).disposed(by: self.disposeBag)
            case .university:
                NetworkService.post(endpoint: .university(university: self.universityInformation), as: University.self).subscribe(onNext: { [weak self] event in
                    guard let self = self else { return }
                    
                    let response = event.1
                    
                    StateManager.of.user.dispatch(university: response)
                    self.navigationController?.popViewController(animated: true)
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
            self.universityInformation.is_active = true
            
            sections = [
                .DetailInformationSection(title: "학력", items: [
                    .AddInformationWithImageItem(style: .university,
                                                 image: UIImage(systemName: "graduationcap.circle.fill") ?? UIImage(),
                                                 information: "학교 이름"),
                    .AddInfomrationLabelItem(style: .major, information: "전공(선택 사항)")
                ]),
                .DetailInformationSection(title: "학력", items: [
                    .SelectDateItem(style: .startDateStyle,
                                    dateInfo: universityInformation.join_date ?? ""),
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
                                                 image: UIImage(systemName: "briefcase.circle.fill") ?? UIImage(),
                                                 information:  (companyInformation.name != nil && companyInformation.name != "") ? companyInformation.name! : "직장 추가"),
                    .AddInfomrationLabelItem(style: .role,
                                             information: (companyInformation.role != nil && companyInformation.role != "") ? companyInformation.role! : "직책(선택 사항)"),
                    .AddInfomrationLabelItem(style: .location,
                                             information: (companyInformation.location != nil && companyInformation.location != "") ? companyInformation.location! : "위치(선택 사항)"),
                    .TextFieldItem(text: companyInformation.detail ?? "")
                ]),
                .DetailInformationSection(title: "직장", items: [
                    .SelectDateItem(style: .startDateStyle,
                                    dateInfo: companyInformation.join_date ?? "")
                ])
            ]
        case .university:
            sections = [
                .DetailInformationSection(title: "학력", items: [
                    .AddInformationWithImageItem(style: .university,
                                                 image: UIImage(systemName: "graduationcap.circle.fill") ?? UIImage(),
                                                 information: (universityInformation.name != nil && universityInformation.name != "") ? universityInformation.name! : "학교 이름"),
                    .AddInfomrationLabelItem(style: .major,
                                             information: (universityInformation.major != nil && universityInformation.major != "") ? universityInformation.major! : "전공(선택 사항)")
                ]),
                .DetailInformationSection(title: "학력", items: [
                    .SelectDateItem(style: .startDateStyle,
                                    dateInfo: universityInformation.join_date ?? ""),
                ])
            ]
        }
        
        self.isActive.accept(true)
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
                                                 image: UIImage(systemName: "briefcase.circle.fill") ?? UIImage(),
                                                 information: (companyInformation.name != nil && companyInformation.name != "") ? companyInformation.name! : "직장 추가"),
                    .AddInfomrationLabelItem(style: .role,
                                             information: (companyInformation.role != nil && companyInformation.role != "") ? companyInformation.role! : "직책(선택 사항)"),
                    .AddInfomrationLabelItem(style: .location,
                                             information: (companyInformation.location != nil && companyInformation.location != "") ? companyInformation.location! : "위치(선택 사항)"),
                    .TextFieldItem(text: companyInformation.detail ?? "")
                ]),
                .DetailInformationSection(title: "직장", items: [
                    .SelectDateItem(style: .startDateStyle,
                                    dateInfo: companyInformation.join_date ?? ""),
                    .SelectDateItem(style: .endDateStyle,
                                    dateInfo: companyInformation.leave_date ?? "")
                ])
            ]
        case .university:
            sections = [
                .DetailInformationSection(title: "학력", items: [
                    .AddInformationWithImageItem(style: .university,
                                                 image: UIImage(systemName: "graduationcap.circle.fill") ?? UIImage(),
                                                 information: (universityInformation.name != nil && universityInformation.name != "") ? universityInformation.name! : "학교 이름"),
                    .AddInfomrationLabelItem(style: .major,
                                             information: (universityInformation.major != nil && universityInformation.major != "") ? universityInformation.major! : "전공(선택 사항)")
                ]),
                .DetailInformationSection(title: "학력", items: [
                    .SelectDateItem(style: .startDateStyle,
                                    dateInfo: universityInformation.join_date ?? ""),
                    .SelectDateItem(style: .endDateStyle,
                                    dateInfo: universityInformation.graduate_date ?? "")
                ])
            ]
        }
        
        self.isActive.accept(false)
        self.sectionsBR.accept(sections)
    }
    
    private func checkHasEntered() {
        switch informationType {
        case .company:
            name.accept(companyInformation.name ?? "")
            start_date.accept(companyInformation.join_date ?? "")
            end_date.accept(companyInformation.leave_date ?? "")
            isActive.accept(companyInformation.is_active!)
        case .university:
            name.accept(universityInformation.name ?? "")
            start_date.accept(universityInformation.join_date ?? "")
            end_date.accept(universityInformation.graduate_date ?? "")
            isActive.accept(universityInformation.is_active!)
        }
    }
    
    let sectionSwitch: UISwitch = {
        let sectionSwitch = UISwitch()
        sectionSwitch.tintColor = .systemBlue
        
        return sectionSwitch
    }()
    
    let sectionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square.fill")!, for: .normal)
        button.tintColor = .systemBlue
        return button
    }()

    
    //UITableView의 custom header적용
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return UIView() }
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 42)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .white
        
        let sectionLabel = UILabel(frame: frame)
        sectionLabel.text = (informationType == .company) ? "현재 재직 중" : "졸업"
        sectionLabel.textColor = .black
        sectionLabel.font = UIFont.systemFont(ofSize: 18)
        
        headerView.addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if self.informationType == .company {
            headerView.addSubview(sectionSwitch)
            sectionSwitch.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                sectionLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                sectionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                sectionSwitch.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                sectionSwitch.heightAnchor.constraint(equalToConstant: 30),
                sectionSwitch.widthAnchor.constraint(equalToConstant: 30),
                sectionSwitch.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -30)
            ])
            
            self.sectionSwitch.isOn = self.companyInformation.is_active ?? true
        } else {
            headerView.addSubview(sectionButton)
            sectionButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                sectionLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                sectionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                sectionButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                sectionButton.heightAnchor.constraint(equalToConstant: 30),
                sectionButton.widthAnchor.constraint(equalToConstant: 30),
                sectionButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -15)
            ])
            
            if self.universityInformation.is_active ?? true {
                sectionButton.setImage(UIImage(systemName: "square")!, for: .normal)
                sectionButton.tintColor = .gray
            } else {
                sectionButton.setImage(UIImage(systemName: "checkmark.square.fill")!, for: .normal)
                sectionButton.tintColor = .systemBlue
            }
        }
        
        return headerView
    }
    
    //footer의 separate line
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .systemGray6
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}

extension AddInformationViewController {
    private func deleteAlert() {
        let alert = UIAlertController(title: "정보를 삭제하시겠어요?", message: "삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { (action) in
            self.saveData()
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    private func backAlert() {
        let alert = UIAlertController(title: "이 페이지에서 나가시겠어요?", message: "이 페이지의 변경 사항이 아직\n저장되지 않았습니다.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let backAction = UIAlertAction(title: "이 페이지 나가기", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(backAction)
        self.present(alert, animated: false, completion: nil)
    }
}
