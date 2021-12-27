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
    
    let sections: [MultipleSectionModel] = [
        .ProfileImageSection(title: "프로필 사진", items: [
            .ProfileImageItem(image: UIImage(systemName: "person.circle.fill")!)
        ]),
        .CoverImageSection(title: "커버 사진", items: [
            .CoverImageItem(image: UIImage(systemName: "photo")!)
        ]),
        .SelfIntroSection(title: "소개", items: [
            .SelfIntroItem(intro: "회원님에 대해 설명해주세요...")
        ]),
        .DetailInformationSection(title: "상세 정보", items: [
            .DetailInformationItem(image: UIImage(systemName: "briefcase")!, information: "직장"),
            .DetailInformationItem(image: UIImage(systemName: "graduationcap")!, information: "학력"),
        ]),
        .EditProfileSection(title: "정보 수정", items: [
            .EditProfileItem(title: "정보 수정")
        ])
    ]
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .MainProfileItem(profileImage, coverImage, name):
            let cell = UITableViewCell()
            
            return cell
        case let .ProfileImageItem(image):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: idxPath) as? ImageTableViewCell else { return UITableViewCell() }
            
            cell.imgView.image = image
            return cell
        case let .CoverImageItem(image):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: idxPath) as? ImageTableViewCell else { return UITableViewCell() }
            
            cell.imgView.image = image
            return cell
        case let .SelfIntroItem(intro):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelfIntroCell", for: idxPath) as? LabelTableViewCell else { return UITableViewCell() }
            
            cell.selfIntroLabel.text = intro
            return cell
        case let .DetailInformationItem(image,information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailProfileCell", for: idxPath) as? DetailProfileTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(style: .style2)
            cell.informationImage.image = image
            cell.informationLabel.text = information
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                let editDetailInformationViewController = EditDetailInformationViewController()
                self?.push(viewController: editDetailInformationViewController)
            }).disposed(by: self.disposeBag)
            
            return cell
        case let .EditProfileItem(title):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell", for: idxPath) as? EditProfileTableViewCell else { return UITableViewCell() }
            
            cell.editProfileButton.setTitleColor(.tintColor, for: .normal)
            cell.editProfileButton.setTitle(title, for: .normal)
            cell.editProfileButton.setImage(UIImage(systemName: "person.text.rectangle"), for: .normal)
            
            cell.editProfileButton.rx.tap.bind { [weak self] in
                let detailProfileViewController = DetailProfileViewController()
                self?.push(viewController: detailProfileViewController)
            }.disposed(by: self.disposeBag)
            
            return cell
        case let .PostItem(post):
            let cell = UITableViewCell()
            
             return cell
        case let .SelectDateItem(title):
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "프로필 편집"
        bindTableView()
    }
    
    func bindTableView() {
        Observable.just(sections).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    //UITableView의 custom header적용
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if section == sections.count - 1 { return UIView() } //마지막 section header 제거
        
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
                print("tap section 1 button!")
            }.disposed(by: disposeBag)
        case 1:
            sectionButton.rx.tap.bind {
                print("tap section 2 button!")
            }.disposed(by: disposeBag)
        case 2:
            sectionButton.rx.tap.bind {
                print("tap section 3 button!")
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
        if section == sections.count - 1 { return 0 } //마지막 section header w제거
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}

