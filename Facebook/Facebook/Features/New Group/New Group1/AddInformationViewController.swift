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
        .DetailInformationSection(title: "직장", items: [
            .DetailInformationItem(image: UIImage(systemName: "briefcase")!, information: "직장 이름")
        ]),
        .DetailInformationSection(title: "직장", items: [
            .SelectDateItem(title: "직장이름")
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailProfileCell", for: idxPath) as? DetailProfileTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(style: .style4)
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                let selectInformationViewController = SelectInformationViewController()
                selectInformationViewController.inforomationType = information.components(separatedBy: " ")[0]
                
                self?.push(viewController: selectInformationViewController)
                
            }).disposed(by: self.disposeBag)
            
            return cell
        case let .EditProfileItem(title):
            let cell = UITableViewCell()
            
            return cell
        case let .PostItem(post):
            let cell = UITableViewCell()
            
            return cell
        case let .SelectDateItem(title):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateSelectTableViewCell.reuseIdentifier, for: idxPath) as? DateSelectTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(style: .startDateStyle)
            cell.setLayout(style: .startDateStyle)
            
            return cell
        }
    }
    
    var informationType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "\(informationType) 추가"
        sectionsBR.accept(sections)
        
        bindTableView()
    }

    private func bindTableView() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}
