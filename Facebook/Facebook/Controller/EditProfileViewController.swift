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
    
    let sections: [MultipleSectionModelOfEditProfileView] = [
        .ProfileImageSection(title: "프로필 사진", items: [.ProfileImageItem(image: UIImage(systemName: "person.circle.fill")!)]),
        .DetailInformationSection(title: "상세 정보", items:
            [.DetailInformationItem(information:"거주지"),
            .DetailInformationItem(information: "직장"),
            .DetailInformationItem(information: "학력"),
            .DetailInformationItem(information: "출신지"),
            .DetailInformationItem(information: "결혼/연애 상태")])
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
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 42)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .gray
        
        let sectionLabel = UILabel(frame: frame)
        sectionLabel.text = dataSource[section].title
        sectionLabel.textColor = .black
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        let sectionButton = UIButton(type: .system)
        sectionButton.setTitle("추가", for: .normal)
        sectionButton.setTitleColor(UIColor.systemBlue, for: .normal)
        sectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sectionButton.tag = section
        sectionButton.addTarget(self, action: #selector(addInformation), for: .touchUpInside)
        
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
    
        return headerView
    }
    
    //footer의 separate line
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
        let footerView = UIView()
        footerView.backgroundColor = .systemBlue
        
        let insets = tableView.separatorInset
        let width = tableView.bounds.width - insets.left - insets.right
        let sepframe = CGRect(x: 0, y: 0, width: width, height: 0.5)
        
        let sep = CALayer()
        sep.frame = sepframe
        sep.backgroundColor = tableView.separatorColor?.cgColor
        footerView.layer.addSublayer(sep)
        
        return footerView
    }
    
    //custom header의 button action
    @objc func addInformation(_ button: UIButton) {
        switch button.tag {
        case 0:
            print("tap section 1 button")
        case 1:
            print("tap section 2 button")
        default:
            print("tap default button")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


extension EditProfileViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<MultipleSectionModelOfEditProfileView>{
        return RxTableViewSectionedReloadDataSource<MultipleSectionModelOfEditProfileView>(
            configureCell: { dataSource, tableView, idxPath, _ in
                switch dataSource[idxPath] {
                case let .ProfileImageItem(image):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: idxPath) as? ProfileImageTableViewCell else { return UITableViewCell() }
                    cell.profileImage.image = image
                    return cell
                case let .DetailInformationItem(information):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailProfileCell", for: idxPath) as? DetailProfileTableViewCell else { return UITableViewCell() }
                    cell.informationLabel.text = information
                    return cell
                }
            }
        )
    }
}

enum MultipleSectionModelOfEditProfileView {
    case ProfileImageSection(title: String, items: [SectionItemOfEditProfileView])
    case DetailInformationSection(title: String, items: [SectionItemOfEditProfileView])
}

enum SectionItemOfEditProfileView {
    case ProfileImageItem(image: UIImage)
    case DetailInformationItem(information: String)
}

extension MultipleSectionModelOfEditProfileView: SectionModelType {
    typealias Item = SectionItemOfEditProfileView
    
    var items: [SectionItemOfEditProfileView] {
        switch  self {
        case .ProfileImageSection(title: _, items: let items):
            return items.map { $0 }
        case .DetailInformationSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: MultipleSectionModelOfEditProfileView, items: [Item]) {
        switch original {
        case let .ProfileImageSection(title: title, items: _):
            self = .ProfileImageSection(title: title, items: items)
        case let .DetailInformationSection(title, _):
            self = .DetailInformationSection(title: title, items: items)
        }
    }
}

extension MultipleSectionModelOfEditProfileView {
    var title: String {
        switch self {
        case .ProfileImageSection(title: let title, items: _):
            return title
        case .DetailInformationSection(title: let title, items: _):
            return title
        }
    }
}
