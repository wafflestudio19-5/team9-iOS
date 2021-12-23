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
    
    let sections: [MultipleSectionModel] = [
        .EditProfileSection(title: "직장", items: [
            .EditProfileItem(title: "직장 추가")
        ]),
        .EditProfileSection(title: "학력", items: [
            .EditProfileItem(title: "고등학교 추가"),
            .EditProfileItem(title: "대학 추가")
        ])
    ]
    
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
            let cell = UITableViewCell()
            
            return cell
        case let .EditProfileItem(title):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell", for: idxPath) as? EditProfileTableViewCell else { return UITableViewCell() }
            
            cell.editProfileButton.setTitleColor(.black, for: .normal)
            cell.editProfileButton.setTitle(title, for: .normal)
            
            cell.editProfileButton.backgroundColor = .systemGray4
            
            cell.editProfileButton.rx.tap.bind { [weak self] in
                let addInformationViewController = AddInformationViewController()
                self?.push(viewController: addInformationViewController)
            }.disposed(by: self.disposeBag)
            
            return cell
        case let .PostItem(post):
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "상세 정보 수정"
        bindTableView()
    }

    func bindTableView() {
        Observable.just(sections).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
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
        
        if section == sections.count - 1 { return UIView() } //마지막 section separator line 젝
        
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
        return 5
    }
}
