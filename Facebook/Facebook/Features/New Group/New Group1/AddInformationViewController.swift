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
    
    
    lazy var isActive: Bool = true
    
    let defaultSections: [MultipleSectionModel] = [
        .DetailInformationSection(title: "직장", items: [
            .SimpleInformationItem(style: .style4, image: UIImage(systemName: "briefcase")!, information: "직장 이름")
        ])
    ]
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay<[MultipleSectionModel]>(value: [])
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .LabelItem(style, labelText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.reuseIdentifier, for: idxPath) as? LabelTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(labelText: labelText)
            
            return cell
        case let .SimpleInformationItem(style, image,information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(image: image, information: information)
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                
                let selectInformationViewController = SelectInformationViewController()
                selectInformationViewController.inforomationType = information.components(separatedBy: " ")[0]
                
                //SelectInformationViewContoller로 부터 데이터를 받음
                selectInformationViewController.selectedInformation
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] item in
                        self?.isActiveSection()
                    }).disposed(by: cell.disposeBag)
                
                self?.push(viewController: selectInformationViewController)
            }).disposed(by: cell.disposeBag)
            
            return cell
        case let .DetailInformationItem(style, image, information, time, description, privacyBound):
            let cell = UITableViewCell()
            
            return cell
        case let .TextFieldItem(text):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.reuseIdentifier, for: idxPath) as? TextViewTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup()
            cell.configureCell()
            
            return cell
        case let .SelectDateItem(style):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateSelectTableViewCell.reuseIdentifier, for: idxPath) as? DateSelectTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell()
            
            return cell
        default:
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    var informationType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "\(informationType) 추가"
        sectionsBR.accept(defaultSections)
        
        bindTableView()
    }

    private func bindTableView() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    //현재 재직 중 상태일 때 TableView의 데이터
    private func isActiveSection() {
        let sections: [MultipleSectionModel] = [
            .DetailInformationSection(title: "직장", items: [
                .SimpleInformationItem(style: .style4, image: UIImage(systemName: "briefcase")!, information: "직장 이름"),
                .LabelItem(style: .style2, labelText: "직책(선택 사항)"),
                .LabelItem(style: .style2, labelText: "위치(선택 사항)"),
                .TextFieldItem(text: "text")
            ]),
            .DetailInformationSection(title: "직장", items: [
                .SelectDateItem(style: .startDateStyle)
            ])
        ]
        
        self.sectionsBR.accept(sections)
    }
    
    //현재 재직 중이 아닐 때 TableView의 데이터 
    private func isNotActiveSection() {
        let sections: [MultipleSectionModel] = [
            .DetailInformationSection(title: "직장", items: [
                .SimpleInformationItem(style: .style4, image: UIImage(systemName: "briefcase")!, information: "직장 이름"),
                .LabelItem(style: .style2, labelText: "직책(선택 사항)"),
                .LabelItem(style: .style2, labelText: "위치(선택 사항)"),
                .TextFieldItem(text: "text")
            ]),
            .DetailInformationSection(title: "직장", items: [
                .SelectDateItem(style: .startDateStyle),
                .SelectDateItem(style: .endDateStyle)
            ])
        ]
        
        self.sectionsBR.accept(sections)
    }
    
    //UITableView의 custom header적용
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if section == 0 { return UIView() }
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 42)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .white
        
        let sectionLabel = UILabel(frame: frame)
        sectionLabel.text = "현재 재직 중"
        sectionLabel.textColor = .black
        sectionLabel.font = UIFont.systemFont(ofSize: 18)
        
        let sectionSwitch = UIButton()
        //sectionSwitch.onTintColor = .systemBlue
        sectionSwitch.setImage(UIImage(systemName: "checkmark.square.fill")!, for: .normal)
        sectionSwitch.tintColor = .systemBlue
        
        headerView.addSubview(sectionLabel)
        headerView.addSubview(sectionSwitch)
        
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            sectionSwitch.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            sectionSwitch.heightAnchor.constraint(equalToConstant: 30),
            sectionSwitch.widthAnchor.constraint(equalToConstant: 30),
            sectionSwitch.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -15)
        ])
        
        sectionSwitch.rx.tap.bind { [weak self]  in
            guard let self = self else { return }
            if self.isActive {
                sectionSwitch.setImage(UIImage(systemName: "square")!, for: .normal)
                self.isNotActiveSection()
                self.isActive = false
            } else {
                sectionSwitch.setImage(UIImage(systemName: "checkmark.square.fill")!, for: .normal)
                self.isActiveSection()
                self.isActive = true
            }
        }.disposed(by: disposeBag)
    
        return headerView
    }
    
    //footer의 separate line
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .systemGray6
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 } //마지막 section header 제거
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
