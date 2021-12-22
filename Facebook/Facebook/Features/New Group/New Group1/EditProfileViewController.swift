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
        .ProfileImageSection(title: "프로필 사진", items: [.ProfileImageItem(image: UIImage(systemName: "person.circle.fill")!)]),
        .CoverImageSection(title: "커버 사진", items: [.CoverImageItem(image: UIImage(systemName: "photo")!)]),
        .SelfIntroSection(title: "소개", items: [.SelfIntroItem(intro: "회원님에 대해 설명해주세요...")]),
        .DetailInformationSection(title: "상세 정보", items:
            [.DetailInformationItem(information:"거주지"),
            .DetailInformationItem(information: "직장"),
            .DetailInformationItem(information: "학력"),
            .DetailInformationItem(information: "출신지"),
            .DetailInformationItem(information: "결혼/연애 상태")]),
        .EditProfileSection(title: "정보 수정", items: [.EditProfileItem(title: "정보 수정")])
    ]
    
    let dataSource = EditProfileViewController.dataSource()
    
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
            }
        case 1:
            sectionButton.rx.tap.bind {
                print("tap section 2 button!")
            }
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


extension EditProfileViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<MultipleSectionModel>{
        return RxTableViewSectionedReloadDataSource<MultipleSectionModel>(
            configureCell: { dataSource, tableView, idxPath, _ in
                switch dataSource[idxPath] {
                case let .ProfileImageItem(image):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: idxPath) as? ImageTableViewCell else { return UITableViewCell() }
                    
                    cell.imgView.image = image
                    return cell
                case let .CoverImageItem(image):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: idxPath) as? ImageTableViewCell else { return UITableViewCell() }
                    
                    cell.imgView.image = image
                    return cell
                case let .SelfIntroItem(intro):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelfIntroCell", for: idxPath) as? SelfIntroTableViewCell else { return UITableViewCell() }
                    
                    cell.selfIntroLabel.text = intro
                    return cell
                case let .DetailInformationItem(information):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailProfileCell", for: idxPath) as? DetailProfileTableViewCell else { return UITableViewCell() }
                    
                    cell.informationLabel.text = information
                    return cell
                case let .EditProfileItem(title):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell", for: idxPath) as? EditProfileTableViewCell else { return UITableViewCell() }
                    
                    cell.editProfileButton.setTitleColor(.tintColor, for: .normal)
                    cell.editProfileButton.setTitle(title, for: .normal)
                    cell.editProfileButton.setImage(UIImage(systemName: "person.text.rectangle"), for: .normal)
                    return cell
                }
            }
        )
    }
}

enum MultipleSectionModel {
    case ProfileImageSection(title: String, items: [SectionItem])
    case CoverImageSection(title: String, items: [SectionItem])
    case SelfIntroSection(title: String, items: [SectionItem])
    case DetailInformationSection(title: String, items: [SectionItem])
    case EditProfileSection(title: String, items: [SectionItem])
}

enum SectionItem {
    case ProfileImageItem(image: UIImage)
    case CoverImageItem(image: UIImage)
    case SelfIntroItem(intro: String)
    case DetailInformationItem(information: String)
    case EditProfileItem(title: String)
}

extension MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch  self {
        case .ProfileImageSection(title: _, items: let items):
            return items.map { $0 }
        case .CoverImageSection(title: _, items: let items):
            return items.map { $0 }
        case .SelfIntroSection(title: _, items: let items):
            return items.map { $0 }
        case .DetailInformationSection(title: _, items: let items):
            return items.map { $0 }
        case .EditProfileSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: MultipleSectionModel, items: [Item]) {
        switch original {
        case let .ProfileImageSection(title: title, items: _):
            self = .ProfileImageSection(title: title, items: items)
        case let .CoverImageSection(title: title, items: _):
            self = .CoverImageSection(title: title, items: items)
        case let .SelfIntroSection(title: title, items: _):
            self = .SelfIntroSection(title: title, items: items)
        case let .DetailInformationSection(title, _):
            self = .DetailInformationSection(title: title, items: items)
        case let .EditProfileSection(title: title, items: _):
            self = .EditProfileSection(title: title, items: items)
        }
    }
}

extension MultipleSectionModel {
    var title: String {
        switch self {
        case .ProfileImageSection(title: let title, items: _):
            return title
        case .CoverImageSection(title: let title, items: _):
            return title
        case .SelfIntroSection(title: let title, items: _):
            return title
        case .DetailInformationSection(title: let title, items: _):
            return title
        case .EditProfileSection(title: let title, items: _):
            return title
        }
    }
}
