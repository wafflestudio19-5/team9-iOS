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
    
    let sections: [MultipleSectionModel] = [
        .DetailInformationSection(title: "생일", items: [
            .BirthSelectItem(style: .birthDay),
            .BirthSelectItem(style: .birthYear)
        ]),
        .DetailInformationSection(title: "이름", items: [
            .EditUsernameItem(username: "이름(한국어)")
        ]),
        .DetailInformationSection(title: "성별", items: [
            .GenderSelectItem(genderText: "여성"),
            .GenderSelectItem(genderText: "남성")
        ])
    ]
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay(value: [])
    
    //TableView 바인딩을 위한 dataSource객체
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    //enum SectionItem의 유형에 따라 다른 cell type을 연결
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .BirthSelectItem(style):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BirthSelectTableViewCell.reuseIdentifier, for: idxPath) as? BirthSelectTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell()
            
            cell.monthSelectButton.rx.tap.bind { [weak self] in
                let dataPopOverViewController = DatePopOverViewController()
                let navigationController = UINavigationController(rootViewController: dataPopOverViewController)
                navigationController.modalPresentationStyle = .popover
                navigationController.popoverPresentationController
                self?.present(navigationController, animated: true, completion: nil)
            }.disposed(by: cell.disposeBag)
            
            return cell
        case let .EditUsernameItem(username):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditUsernameTableViewCell.reuseIdentifier, for: idxPath) as? EditUsernameTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(username: username)
            
            cell.addButton.rx.tap.bind { [weak self] in
                let editUsernameViewController = EditUsernameViewController()
                self?.push(viewController: editUsernameViewController)
            }.disposed(by: cell.disposeBag)
            
            return cell
        case let .GenderSelectItem(genderText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GenderSelectTableViewCell.reuseIdentifier, for: idxPath) as? GenderSelectTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(genderText: genderText)
            
            return cell
        default:
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sectionsBR.accept(sections)
        bindTableView()
    }
    

    func bindTableView() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
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
