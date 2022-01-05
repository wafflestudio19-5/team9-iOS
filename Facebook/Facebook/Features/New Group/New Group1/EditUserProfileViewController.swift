//
//  EditUserProfileViewController.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class EditUserProfileViewController<View: EditUserProfileView>: UIViewController, UITableViewDelegate {

    override func loadView() {
        view = View()
    }
    
    var editUserProfileView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    var tableView: UITableView {
        editUserProfileView.editUserProfileTableView
    }
    
    let disposeBag = DisposeBag()
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay(value: [])
    
    //TableView 바인딩을 위한 dataSource객체
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    //enum SectionItem의 유형에 따라 다른 cell type을 연결
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .BirthSelectItem(style, birthInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BirthSelectTableViewCell.reuseIdentifier, for: idxPath) as? BirthSelectTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(birthInfo: birthInfo)
            
            switch style {
            case .birthDay:
                self.selectedMonth = cell.monthTextField.text ?? ""
                self.selectedDay = cell.dayTextField.text ?? ""
                
                cell.monthTextField.rx.text.orEmpty.subscribe { [weak self] selectedMonth in
                    self?.selectedMonth = selectedMonth
                }.disposed(by: cell.disposeBag)
                
                cell.dayTextField.rx.text.orEmpty.subscribe { [weak self] selectedDay in
                    self?.selectedDay = selectedDay
                }.disposed(by: cell.disposeBag)
            case .birthYear:
                self.selectedYear = cell.yearTextField.text ?? ""
                
                cell.yearTextField.rx.text.orEmpty.subscribe { [weak self] selectedYear in
                    self?.selectedYear = selectedYear
                }.disposed(by: cell.disposeBag)
            }
            
            return cell
        case let .EditUsernameItem(username):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditUsernameTableViewCell.reuseIdentifier, for: idxPath) as? EditUsernameTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(username: username)
            
            cell.addButton.rx.tap.bind { [weak self] in
                let editUsernameViewController = EditUsernameViewController()
                self?.push(viewController: editUsernameViewController)
            }.disposed(by: cell.disposeBag)
            
            return cell
        case let .GenderSelectItem(style, selectedGender):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GenderSelectTableViewCell.reuseIdentifier, for: idxPath) as? GenderSelectTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            switch style {
            case .male:
                cell.configureCell(genderText: "남성")
            case .female:
                cell.configureCell(genderText: "여성")
            }
            
            //성별 선택에 따른 선택 이미지 변경
            cell.rx.tapGesture().when(.recognized).subscribe({ [weak self] _ in
                switch cell.cellStyle {
                case .male:
                    self?.selectedGender = "M"
                    self?.genderBS.onNext("M")
                case .female:
                    self?.selectedGender = "F"
                    self?.genderBS.onNext("F")
                }
            }).disposed(by: cell.disposeBag)
            
            self.genderBS.subscribe(onNext: { gender in
                cell.genderPS.onNext(gender)
            }).disposed(by: cell.disposeBag)
            
            //초기 성별 선택 이미지 설정
            cell.genderPS.onNext(self.selectedGender)
            
            return cell
        default:
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    var userProfile: UserProfile?
    
    var selectedYear = ""
    var selectedMonth = ""
    var selectedDay = ""
    var selectedGender = ""
    let genderBS = BehaviorSubject<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadData()
        bindTableView()
    }
    
    func loadData() {
        NetworkService.get(endpoint: .profile(id: 41), as: UserProfile.self)
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
        
        selectedGender = userProfile.gender
        
        let sections: [MultipleSectionModel] = [
            .DetailInformationSection(title: "생일", items: [
                .BirthSelectItem(style: .birthDay, birthInfo: userProfile.birth),
                .BirthSelectItem(style: .birthYear, birthInfo: userProfile.birth)
            ]),
            .DetailInformationSection(title: "이름", items: [
                .EditUsernameItem(username: "이름(한국어)")
            ]),
            .DetailInformationSection(title: "성별", items: [
                .GenderSelectItem(style: .female, selectedGender: userProfile.gender),
                .GenderSelectItem(style: .male, selectedGender: userProfile.gender)
            ])
        ]
        
        sectionsBR.accept(sections)
    }

    func bindTableView() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        editUserProfileView.saveButton.rx.tap.bind{ [weak self] _ in
            guard let self = self else { return }
            
            var month = self.selectedMonth.trimmingCharacters(in: ["월"])
            if month.count == 1 {
                month = "0" + month
            }
            
            var day = self.selectedDay
            if day.count == 1 {
                day = "0" + day
            }
        
            let birth = self.selectedYear + "-" + month + "-" + day
            self.userProfile?.birth = birth
            self.userProfile?.gender = self.selectedGender
            
            guard let userProfile = self.userProfile else { return }
            
            NetworkService
                .put(endpoint: .profile(id: 41, userProfile: userProfile), as: UserProfile.self)
                .subscribe { [weak self] _ in
                    guard let self = self else { return }
                    let VCcount = self.navigationController?.viewControllers.count
                    guard let detailProfileVC = self.navigationController?.viewControllers[VCcount! - 2] as? DetailProfileViewController else { return }
                    detailProfileVC.loadData()
                    self.navigationController?.popViewController(animated: true)
                }.disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        editUserProfileView.cancelButton.rx.tap.bind{
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 20)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .systemGray5
        
        let sectionLabel = UILabel(frame: frame)
        sectionLabel.text = dataSource[section].title
        sectionLabel.textColor = .darkGray
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        headerView.addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { //마지막 section header w제거
        return 30
    }
    
}
