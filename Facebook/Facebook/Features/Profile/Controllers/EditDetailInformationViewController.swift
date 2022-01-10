//
//  EditDetailInformationViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class EditDetailInformationViewController<View: EditDetailInformationView>: UIViewController, UITableViewDelegate {
    
    override func loadView() {
        view = View()
    }
    
    var editDetailInformationView: View {
        guard let view = view as? View else { return View() }
        return view
    }

    var tableView: UITableView {
        editDetailInformationView.editDetailInformationTableView
    }
    
    let disposeBag = DisposeBag()
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay<[MultipleSectionModel]>(value: [])
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .CompanyItem(company):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailInformationTableViewCell.reuseIdentifier, for: idxPath) as? DetailInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style4)
            cell.configureCell(image: UIImage(),
                               information: company.name ?? "",
                               time: "",
                               description: "",
                               privacyBound: "")
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                cell.toggleIndicate()
            }).disposed(by: cell.disposeBag)
            
            cell.editButton.rx.tap.bind { [weak self] in
                let addInformationViewController = AddInformationViewController(informationType: .company, id: company.id ?? nil)
                self?.push(viewController: addInformationViewController)
            }.disposed(by: cell.disposeBag)
            
            return cell
        case let .UniversityItem(university):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailInformationTableViewCell.reuseIdentifier, for: idxPath) as? DetailInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style4)
            cell.configureCell(image: UIImage(),
                               information: university.name ?? "",
                               time: "",
                               description: "",
                               privacyBound: "")
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                cell.toggleIndicate()
            }).disposed(by: cell.disposeBag)
            
            cell.editButton.rx.tap.bind { [weak self] in
                let addInformationViewController = AddInformationViewController(informationType: .university, id: university.id ?? nil)
                self?.push(viewController: addInformationViewController)
            }.disposed(by: cell.disposeBag)
            
            return cell
        case let .AddInformationButtonItem(style, buttonText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: idxPath) as? ButtonTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style3)
            cell.configureCell(buttonText: buttonText)
            
            /* cell.button.rx.tap.bind { [weak self] in
                let addInformationViewController = AddInformationViewController(informationType: style)
                self?.push(viewController: addInformationViewController)
            }.disposed(by: cell.disposeBag) */
            
            return cell
        default:
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "상세 정보 수정"
        loadData()
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //제일 처음 로드되었을 때(userProfile == nil 일때)를 제외하고 화면이 보일 때 유저 프로필 데이터 리로드
        if userProfile != nil {
            loadData()
        }
    }
    
    func loadData() {
        NetworkService.get(endpoint: .profile(id: CurrentUser.shared.profile?.id ?? 0), as: UserProfile.self)
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
            
                self.userProfile = response
                
                self.createSection()
                
        }.disposed(by: disposeBag)
    }
    
    func createSection() {
        guard let userProfile = userProfile else { return }
        
        let companyItems = userProfile.company.map({ company in
            SectionItem.CompanyItem(company: company)
        })
        
        let addCompanyButtonItem: [SectionItem] = [
            .AddInformationButtonItem(style: .company, buttonText: "직장 추가")
        ]
    
        let universityItems = userProfile.university.map({ university in
            SectionItem.UniversityItem(university: university)
        })
        
        let addUniversityButtonItem: [SectionItem] = [
            .AddInformationButtonItem(style: .university, buttonText: "대학 추가"),
        ]
        
        let sections: [MultipleSectionModel] = [
            .EditProfileSection(title: "직장", items: companyItems + addCompanyButtonItem),
            .EditProfileSection(title: "학력", items: universityItems + addUniversityButtonItem)
        ]
        
        sectionsBR.accept(sections)
    }

    func bindTableView() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    //UITableView의 custom header적용
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 42)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .white
        
        let sectionLabel = UILabel(frame: frame)
        sectionLabel.text = dataSource[section].title
        sectionLabel.textColor = .black
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        headerView.addSubview(sectionLabel)
        
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15)
        ])
    
        return headerView
    }
    
    //footer의 separate line
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 1 { return UIView() } 
        
        let footerView = UIView()
        footerView.backgroundColor = .white
        
        let width = tableView.bounds.width - 20
        let sepframe = CGRect(x: 10, y: 0, width: width, height: 0.5)
        
        let sep = CALayer()
        sep.frame = sepframe
        sep.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        footerView.layer.addSublayer(sep)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == sectionsBR.value.count - 1 { return 0 }
        return 5
    }
}
