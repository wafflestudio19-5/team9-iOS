//
//  PhotoPopUpViewController.swift
//  Facebook
//
//  Created by 김우성 on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PhotoPopUpViewController<View: PhotoPopUpView>: UIViewController {

    override func loadView() {
        view = View()
    }
    
    var photoPopUpView: View {
        guard let view = view as? View else { return View() }
        return view
    }

    var tableView: UITableView {
        photoPopUpView.photoPopUpTableView
    }
    
    let disposeBag = DisposeBag()
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay<[MultipleSectionModel]>(value: [])
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .SimpleInformationItem(style, informationType, image, information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(image: image, information: information)
            
            return cell
        default:
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    let section: [MultipleSectionModel] = [
        .DetailInformationSection(title: "사진 업로드 옵션", items: [
            .SimpleInformationItem(style: .style3,
                                   image: UIImage(),
                                   information: "프로필 사진 선택"),
            .SimpleInformationItem(style: .style3,
                                   image: UIImage(),
                                   information: "Instagrame과 동기화")
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sectionsBR.accept(section)
        bind()
    }
    
    func bind() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}
