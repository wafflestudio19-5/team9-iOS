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
import RxDataSources

class DetailProfileViewController<View: DetailProfileView>: UIViewController, UITableViewDelegate {

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
    let dateFormatter = DateFormatter()
    
    //TableView 바인딩을 위한 dataSource객체
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    //enum SectionItem의 유형에 따라 다른 cell type을 연결
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .SimpleInformationItem(style, informationType, image, information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(image: image, information: information)
            
            if self.userId == UserDefaultsManager.cachedUser?.id {
                cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                    guard let informationType = informationType else { return }
                    
                    let addInformationViewController = AddInformationViewController(informationType: informationType)
                    self?.push(viewController: addInformationViewController)
                }).disposed(by: cell.disposeBag)
            }
            
            return cell
        case let .DetailInformationItem(style, image, information, time, description, privacyBound):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailInformationTableViewCell.reuseIdentifier, for: idxPath) as? DetailInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(image: image, information: information, time: time, description: description, privacyBound: privacyBound)
            
            return cell
        case let .CompanyItem(company):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailInformationTableViewCell.reuseIdentifier, for: idxPath) as?
                DetailInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style3)
            
            cell.configureCell(image: UIImage(systemName: "briefcase.circle")!,
                               information: company.name ?? "",
                               time: Date().changeDateStringFormat(startDateString: company.join_date ?? "", endDateString: company.leave_date ?? ""),
                               description: company.detail ?? "",
                               privacyBound: "전체 공개")
            
            if self.userId == UserDefaultsManager.cachedUser?.id {
                cell.editButton.rx.tap.bind { [weak self] in
                    let addInformationViewController = AddInformationViewController(informationType: .company, id: company.id ?? nil)
                    self?.push(viewController: addInformationViewController)
                }.disposed(by: cell.disposeBag)
            } else {
                cell.editButton.isHidden = true
            }
            
            return cell
        case let .UniversityItem(university):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailInformationTableViewCell.reuseIdentifier, for: idxPath) as?
                DetailInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style3)
            
            cell.configureCell(image: UIImage(systemName: "graduationcap.circle")!,
                               information: university.name ?? "",
                               time: Date().changeDateStringFormat(startDateString: university.join_date ?? "", endDateString: university.graduate_date ?? ""),
                               description: "",
                               privacyBound: "전체 공개")
            
            if self.userId == UserDefaultsManager.cachedUser?.id {
                cell.editButton.rx.tap.bind { [weak self] in
                    let addInformationViewController = AddInformationViewController(informationType: .university, id: university.id ?? nil)
                    self?.push(viewController: addInformationViewController)
                }.disposed(by: cell.disposeBag)
            } else {
                cell.editButton.isHidden = true
            }
            
            return cell
        case let .PostItem(post):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: idxPath) as? PostCell else { return UITableViewCell() }
            
            cell.configure(with: post)
            return cell
        default:
            let cell = UITableViewCell()
            return cell 
        }
    }
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay(value: [])
    
    private var userId: Int
    private var userProfile: UserProfile?
    
    init(userId: Int) {
        //자신의 프로필을 보는지, 다른 사람의 프로필을 보는 것인지
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "정보"
        setNavigationItem()
        if userId != UserDefaultsManager.cachedUser?.id { loadData() }
        bind()
    }
    
    private func setNavigationItem() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        NetworkService.get(endpoint: .profile(id: self.userId), as: UserProfile.self)
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
        var userProfile: UserProfile
        if userId == UserDefaultsManager.cachedUser?.id {
            userProfile = StateManager.of.user.profile
        } else {
            userProfile = self.userProfile!
        }

        var companyItems = userProfile.company.map({ company in
            SectionItem.CompanyItem(company: company)
        })
        
        var universityItems = userProfile.university.map({ university in
            SectionItem.UniversityItem(university: university)
        })
        
        var sections: [MultipleSectionModel]
        if userId == UserDefaultsManager.cachedUser?.id {
            sections = [
                .DetailInformationSection(title: "직장", items: [
                    .SimpleInformationItem(style: .style3,
                                           informationType: .company,
                                           image: UIImage(systemName: "briefcase.circle") ?? UIImage(),
                                           information: "직장 추가")
                ] + companyItems ),
                .DetailInformationSection(title: "학력", items:[
                    .SimpleInformationItem(style: .style3,
                                           informationType: .university,
                                           image: UIImage(systemName: "graduationcap.circle") ?? UIImage(),
                                           information: "학력 추가")
                ] + universityItems ),
                .DetailInformationSection(title: "연락처 정보", items: [
                    .DetailInformationItem(style: .style2,
                                           image: UIImage(systemName: "envelope.circle")!,
                                           information: userProfile.email,
                                           description: "이메일",
                                           privacyBound: "전체 공개" )]),
                .DetailInformationSection(title: "기본 정보", items: [
                    .DetailInformationItem(style: .style1,
                                           image: UIImage(systemName: "person.circle")!,
                                           information: (userProfile.gender == "M") ? "남성" : "여성",
                                           description: "성별"),
                    .DetailInformationItem(style: .style2,
                                           image: UIImage(systemName: "gift.circle")!,
                                           information:
                                            (userProfile.birth != "") ?
                                            String(userProfile.birth.split(separator: "-")[0]) + "년 " +
                                            String(userProfile.birth.split(separator: "-")[1]) + "월 " +
                                           String(userProfile.birth.split(separator: "-")[2]) + "일 " : "",
                                           description: "생일",
                                           privacyBound: "전체 공개")
                ])
            ]
        } else {
            if companyItems.count == 0 {
                companyItems = [ .SimpleInformationItem(style: .style3,
                                                        informationType: .company,
                                                        image: UIImage(systemName: "briefcase.circle") ?? UIImage(),
                                                        information: "표시할 직장 정보 없음") ]
            }
            
            if universityItems.count == 0 {
                universityItems = [ .SimpleInformationItem(style: .style3,
                                           informationType: .company,
                                           image: UIImage(systemName: "graduationcap.circle") ?? UIImage(),
                                           information: "표시할 학교 정보 없음") ]
            }
            
            let birthInfo = String(userProfile.birth.split(separator: "-")[0]) + "년 " +                     String(userProfile.birth.split(separator: "-")[1]) + "월 " +
                            String(userProfile.birth.split(separator: "-")[2]) + "일 "
            
            sections = [
                .DetailInformationSection(title: "직장", items: companyItems),
                .DetailInformationSection(title: "학력", items: universityItems),
                .DetailInformationSection(title: "연락처 정보", items: [
                    .DetailInformationItem(style: .style2,
                                           image: UIImage(systemName: "envelope.circle")!,
                                           information: userProfile.email,
                                           description: "이메일",
                                           privacyBound: "전체 공개" )]),
                .DetailInformationSection(title: "기본 정보", items: [
                    .DetailInformationItem(style: .style1,
                                           image: UIImage(systemName: "person.circle")!,
                                           information: (userProfile.gender == "M") ? "남성" : "여성",
                                           description: "성별"),
                    .DetailInformationItem(style: .style2,
                                           image: UIImage(systemName: "gift.circle")!,
                                           information: birthInfo,
                                           description: "생일",
                                           privacyBound: "전체 공개")
                ])
            ]
        }
        
        sectionsBR.accept(sections)
    }
    
    func bind() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        if userId == UserDefaultsManager.cachedUser?.id {
            StateManager.of.user
                .asObservable()
                .bind { [weak self] _ in
                    self?.createSection()
                }.disposed(by: disposeBag)
        }
        
        /// 새로고침 제스쳐
        detailProfileView.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.loadData()
                self.tableView.refreshControl?.endRefreshing()
            }).disposed(by: disposeBag)
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
        
        if userId == UserDefaultsManager.cachedUser?.id {
            if section == 3 {
                let sectionButton = UIButton(type: .system)
                sectionButton.setTitle("수정", for: .normal)
                sectionButton.setTitleColor(UIColor.systemBlue, for: .normal)
                sectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                headerView.addSubview(sectionButton)
                sectionButton.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    sectionButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                    sectionButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -15)
                ])
               
                sectionButton.rx.tap.bind { [weak self] in
                    let editUserProfileViewController = EditUserProfileViewController()
                    self?.push(viewController: editUserProfileViewController)
                }.disposed(by: disposeBag)
            }
        }
        
        return headerView
    }
    
    //footer의 separate line
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
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

extension Date {
    func changeDateStringFormat(startDateString: String, endDateString: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        guard let startDate = dateFormatter.date(from: startDateString) else { return "" }
        dateFormatter.dateFormat = "YYYY년 MM월 DD일"
        let startResult = dateFormatter.string(from: startDate)
        
        if endDateString != nil && endDateString != "" {
            dateFormatter.dateFormat = "YYYY-MM-DD"
            guard let endDate = dateFormatter.date(from: endDateString ?? "") else { return startResult + " - 현재" }
            dateFormatter.dateFormat = "YYYY년 MM월 DD일"
            let endResult = dateFormatter.string(from: endDate)
            
            return startResult + " ~ " + endResult
        }
        
        
        if self.dateCompare(dateString: startDateString) {
            return startResult + "에 시작"
        } else {
            return startResult + " - 현재"
        }
    }
    
    func dateCompare(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        guard let date = dateFormatter.date(from: dateString) else { return true }
        let result: ComparisonResult = self.compare(date)
        
        switch result {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
}
