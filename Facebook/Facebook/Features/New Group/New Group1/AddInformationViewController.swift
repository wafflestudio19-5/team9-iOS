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

class AddInformationViewController<View: AddInformationView>: UIViewController {

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
    
    let sections: [MultipleSectionModel] = [
        .EditProfileSection(title: "직장", items: [
            .EditProfileItem(title: "직장 추가")
        ])
    ]
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay<[MultipleSectionModel]>(value: [])
    
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
                let selectInformationViewController = SelectInformationViewController()
                self?.push(viewController: selectInformationViewController)
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
        self.title = "정보 추가"
        sectionsBR.accept(sections)
        
        bindTableView()
    }

    private func bindTableView() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}
