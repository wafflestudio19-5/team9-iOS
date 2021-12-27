//
//  DetailProfileViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/14.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources

class DetailProfileViewController<View: DetailProfileView>: UIViewController, UITableViewDelegate {

    override func loadView() {
        view = View()
    }

    var detailProfileView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    var tableView: UITableView {
        detailProfileView.detailProfileTableView
    }
    
    let disposeBag = DisposeBag()
    
    let sections: [MultipleSectionModel] = [
        .DetailInformationSection(title: "직장", items: [
            .DetailInformationItem(image: UIImage(systemName: "briefcase")!,information: "직장 추가")
        ]),
        .DetailInformationSection(title: "학력", items:[
            .DetailInformationItem(image: UIImage(systemName: "graduationcap")!,information: "대학교 추가"),
            .DetailInformationItem(image: UIImage(systemName: "graduationcap")!,information: "고등학교 추가")
        ]),
        .DetailInformationSection(title: "연락처 정보", items: [
            .DetailInformationItem(image: UIImage(systemName: "phone.fill")!,information: "010-1234-5678")
        ]),
        .DetailInformationSection(title: "기본 정보", items: [
            .DetailInformationItem(image: UIImage(systemName: "person.fill")!,information: "남성"),
            .DetailInformationItem(image: UIImage(systemName: "gift.fill")!,information: "0000년 00월 00일")
        ])
    ]
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .MainProfileItem(profileImage, coverImage, name):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainProfileCell", for: idxPath) as? MainProfileTableViewCell else { return UITableViewCell() }
            
            cell.profileImage.image = profileImage
            cell.coverImage.image = coverImage
            cell.nameLabel.text = name
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
            
            cell.configureCell(style: .style3)
            cell.informationImage.image = image
            cell.informationLabel.text = information
            return cell
        case let .EditProfileItem(title):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell", for: idxPath) as? EditProfileTableViewCell else { return UITableViewCell() }
            
            cell.editProfileButton.setTitleColor(.tintColor, for: .normal)
            cell.editProfileButton.setTitle(title, for: .normal)
            cell.editProfileButton.setImage(UIImage(systemName: "person.text.rectangle"), for: .normal)
            
            return cell
        case let .PostItem(post):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: idxPath) as? PostCell else { return UITableViewCell() }
            
            cell.configureCell(with: post)
            return cell
        case let .SelectDateItem(title):
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "정보"
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
        
        if section == 2 || section == 3 {
            let sectionButton = UIButton(type: .system)
            sectionButton.setTitle("수정", for: .normal)
            sectionButton.setTitleColor(UIColor.systemBlue, for: .normal)
            sectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            headerView.addSubview(sectionButton)
            sectionButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                sectionButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                sectionButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -15)
            ])
            
            switch section {
            case 2:
                sectionButton.rx.tap.bind {
                    print("tap section 3 button!")
                }
            case 3:
                sectionButton.rx.tap.bind {
                    print("tap section 4 button!")
                }
            default: break
            }
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { //마지막 section header w제거
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
