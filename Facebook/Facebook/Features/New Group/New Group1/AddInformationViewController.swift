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
            .InformationItem(image: UIImage(systemName: "briefcase")!, information: "직장 이름")
        ]),
        .DetailInformationSection(title: "직장", items: [
            .SelectDateItem(style: .startDateStyle),
            .SelectDateItem(style: .endDateStyle)
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
        case let .LabelItem(labelText):
            let cell = UITableViewCell()
            
            return cell
        case let .InformationItem(image,information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.reuseIdentifier, for: idxPath) as? InformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style4)
            cell.configureCell(image: image, information: information)
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                let selectInformationViewController = SelectInformationViewController()
                selectInformationViewController.inforomationType = information.components(separatedBy: " ")[0]
                
                //SelectInformationViewContoller로 부터 데이터를 받음
                selectInformationViewController.selectedInformation
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] item in
                        
                        let sections: [MultipleSectionModel] = [
                            .DetailInformationSection(title: "직장", items: [
                                .InformationItem(image: UIImage(systemName: "briefcase")!, information: "직장 이름"),
                                .InformationItem(image: UIImage(systemName: "briefcase")!, information: "직책(선택 사항)"),
                                .InformationItem(image: UIImage(systemName: "briefcase")!, information: "위치(선택 사항)"),
                                .InformationItem(image: UIImage(systemName: "briefcase")!, information: "직업에 대해 설명해주세요(선택 사항)")
                            ]),
                            .DetailInformationSection(title: "직장", items: [
                                .SelectDateItem(style: .startDateStyle)
                            ])
                        ]
                        
                        self?.sectionsBR.accept(sections)
                        
                    }).disposed(by: cell.disposeBag)
                
                self?.push(viewController: selectInformationViewController)
                
            }).disposed(by: self.disposeBag)
            
            return cell
        case let .ButtonItem(buttonText):
            let cell = UITableViewCell()
            
            return cell
        case let .PostItem(post):
            let cell = UITableViewCell()
            
            return cell
        case let .SelectDateItem(style):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateSelectTableViewCell.reuseIdentifier, for: idxPath) as? DateSelectTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell()
            
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
