//
//  EditProfileViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/14.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

class EditProfileViewController<View: EditProfileView>: UIViewController, UITableViewDelegate{

    override func loadView() {
        view = View()
    }
    
    var editProfileView: View {
        guard let view = view as? View else { return View() }
        return view
    }

    var tableView: UITableView {
        editProfileView.editProfileTableView
    }
    
    let disposeBag = DisposeBag()
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay<[MultipleSectionModel]>(value: [])
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .ImageItem(image):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: idxPath) as? ImageTableViewCell else { return UITableViewCell() }
            
            cell.imgView.image = image
            return cell
        case let .SimpleInformationItem(style, informationType, image, information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(image: image, information: information)
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                let editDetailInformationViewController = EditDetailInformationViewController()
                self?.push(viewController: editDetailInformationViewController)
            }).disposed(by: self.disposeBag)
            
            return cell
        case let .LabelItem(style, labelText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.reuseIdentifier, for: idxPath) as? LabelTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(labelText: labelText)
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                if self.userProfile?.self_intro == nil {
                    let addSelfIntroViewController = AddSelfIntroViewController()
                    let navigationController = UINavigationController(rootViewController: addSelfIntroViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: nil)
                } else {
                    let alertMenu = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
                    
                    let editSelfIntroAction = UIAlertAction(title: "소개 수정", style: .default, handler: nil)
                    editSelfIntroAction.setValue(0, forKey: "titleTextAlignment")
                    editSelfIntroAction.setValue(UIImage(systemName: "pencil.circle")!, forKey: "image")
                    
                    let deleteSelfIntroAction = UIAlertAction(title: "소개 삭제", style: .default, handler: nil)
                    deleteSelfIntroAction.setValue(0, forKey: "titleTextAlignment")
                    deleteSelfIntroAction.setValue(UIImage(systemName: "trash.circle")!, forKey: "image")
                    
                    let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
                    
                    alertMenu.addAction(editSelfIntroAction)
                    alertMenu.addAction(deleteSelfIntroAction)
                    alertMenu.addAction(cancelAction)
                    
                    self.present(alertMenu, animated: true, completion: nil)
                }
            }).disposed(by: cell.disposeBag)
            
            return cell
        case let .ButtonItem(style, buttonText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: idxPath) as? ButtonTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(buttonText: buttonText)
            
            cell.button.rx.tap.bind { [weak self] in
                let detailProfileViewController = DetailProfileViewController()
                self?.push(viewController: detailProfileViewController)
            }.disposed(by: cell.disposeBag)
            
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
        self.title = "프로필 편집"
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
        
        let companyItems = userProfile.company?.map({ company in
            SectionItem.CompanyItem(company: company)
        }) ?? []
        
        let universityItems = userProfile.university?.map({ university in
            SectionItem.UniversityItem(university: university)
        }) ?? []
        
        let sections: [MultipleSectionModel] = [
            .ProfileImageSection(title: "프로필 사진", items: [
                .ImageItem(image: UIImage(systemName: "person.circle.fill")!)
            ]),
            .CoverImageSection(title: "커버 사진", items: [
                .ImageItem(image: UIImage(systemName: "photo")!)
            ]),
            .SelfIntroSection(title: "소개", items: [
                .LabelItem(style: .style1, labelText: userProfile.self_intro ?? "회원님에 대해 설명해주세요...")
            ]),
            .DetailInformationSection(title: "상세 정보", items: [
                .SimpleInformationItem(style: .style2, image: UIImage(systemName: "briefcase")!, information: "직장"),
                .SimpleInformationItem(style: .style2, image: UIImage(systemName: "graduationcap")!, information: "학력"),
            ] + companyItems + universityItems),
            .EditProfileSection(title: "정보 수정", items: [
                .ButtonItem(style: .style2, buttonText: "정보 수정")
            ])
        ]
        
        sectionsBR.accept(sections)
    }
    
    func bindTableView() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    //UITableView의 custom header적용
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if section == 4 { return UIView() } //마지막 section header 제거
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 42)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .white
        
        let sectionLabel = UILabel(frame: frame)
        sectionLabel.text = dataSource[section].title
        sectionLabel.textColor = .black
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        let sectionButton = UIButton(type: .system)
        sectionButton.setTitle("추가", for: .normal)
        sectionButton.setTitleColor(UIColor.systemBlue, for: .normal)
        sectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sectionButton.tag = section
        
        headerView.addSubview(sectionLabel)
        headerView.addSubview(sectionButton)
        
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            sectionButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            sectionButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -15)
        ])
        
        switch section {
        case 0:
            sectionButton.rx.tap.bind {
                
            }.disposed(by: disposeBag)
        case 1:
            sectionButton.rx.tap.bind {
                print("tap section 2 button!")
            }.disposed(by: disposeBag)
        case 2:
            sectionButton.rx.tap.bind {
                let addSelfIntroViewController = AddSelfIntroViewController()
                let navigationController = UINavigationController(rootViewController: addSelfIntroViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        case 3:
            sectionButton.rx.tap.bind {
                let editDetailInformationViewController = EditDetailInformationViewController()
                self.push(viewController: editDetailInformationViewController)
            }.disposed(by: disposeBag)
        default: break
        }
    
        return headerView
    }
    
    //footer의 separate line
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 4 { return UIView() } //마지막 section separator line 젝
        
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
        if section == 4 { return 0 } //마지막 section header w제거
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}

