//
//  ProfileTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources

class ProfileTabViewController: BaseTabViewController<ProfileTabView>, UITableViewDelegate {

    var tableView: UITableView {
        tabView.profileTableView
    }

    let sections: [MultipleSectionModel] = [
        .ProfileImageSection(title: "메인 프로필", items: [
            .MainProfileItem(profileImage: UIImage(systemName: "person.fill")!, coverImage: UIImage(), name: "name")
        ]),
        .DetailInformationSection(title: "상세 정보", items: [
            .SimpleInformationItem(style: .style1, image: UIImage(systemName: "briefcase.fill")!, information: "경력"),
            .SimpleInformationItem(style: .style1, image: UIImage(systemName: "graduationcap.fill")!, information: "학력"),
            .SimpleInformationItem(style: .style1, image: UIImage(systemName: "ellipsis")!, information: "내 정보 보기"),
            .ButtonItem(style: .style1, buttonText: "전체 공개 정보 수정")
        ]),
        .PostSection(title: "내가 쓴 글", items: [
            
        ])
    ]

    let postData = PaginationViewModel<Post>(endpoint: .newsfeed())
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay(value: [])
    
    //TableView 바인딩을 위한 dataSource객체
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    //enum SectionItem의 유형에 따라 다른 cell type을 연결
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .MainProfileItem(profileImage, coverImage, name):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainProfileCell", for: idxPath) as? MainProfileTableViewCell else { return UITableViewCell() }
            
            cell.profileImage.image = profileImage
            cell.coverImage.image = coverImage
            cell.nameLabel.text = name
            
            cell.profileImage.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                print("profile image Tap")
            }).disposed(by: self.disposeBag)
            
            cell.coverImageButton.rx.tap.bind { [weak self] in
                print("cover image button tap")
            }.disposed(by: self.disposeBag)
            
            cell.editProfileButton.rx.tap.bind { [weak self] in
                let editProfileViewController = EditProfileViewController()
                self?.push(viewController: editProfileViewController)
            }.disposed(by: self.disposeBag)
            
            return cell
        case let .SimpleInformationItem(style, informationType,image, information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(image: image, information: information)
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                let detailProfileViewController = DetailProfileViewController()
                self?.push(viewController: detailProfileViewController)
            }).disposed(by: self.disposeBag)
            
            return cell
        case let .ButtonItem(style, buttonText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: idxPath) as? ButtonTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(buttonText: buttonText)
            
            cell.button.rx.tap.bind { [weak self] in
                let editProfileViewController = EditProfileViewController()
                self?.push(viewController: editProfileViewController)
            }.disposed(by: self.disposeBag)
            
            return cell
        case let .PostItem(post):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: idxPath) as? PostCell else { return UITableViewCell() }

            cell.configureCell(with: post)
            return cell
        default:
            let cell = UITableViewCell()
            
            return cell 
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        super.setNavigationBarItems(withEditButton: true)
        
        sectionsBR.accept(sections)
        bindTableView()
    }
    
    func bindTableView() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        /// `isLoading` 값이 바뀔 때마다 하단 스피너를 토글합니다.
        postData.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.tabView.showBottomSpinner()
                } else {
                    self?.tabView.hideBottomSpinner()
                }
            })
            .disposed(by: disposeBag)
        
        /// 새로고침 제스쳐가 인식될 때마다 `refresh` 함수를 실행합니다.
        tabView.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.postData.refresh()
            })
            .disposed(by: disposeBag)
        
        /// 새로고침이 완료될 때마다 `refreshControl`의 애니메이션을 중단시킵니다.
        postData.refreshComplete
            .asDriver()
            .drive(onNext : { [weak self] refreshComplete in
                if refreshComplete {
                    self?.tabView.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        /// 테이블 맨 아래까지 스크롤할 때마다 `loadMore` 함수를 실행합니다.
        tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.tableView.contentOffset.y
            let contentHeight = self.tableView.contentSize.height
            
            if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                self.postData.loadMore()
            }
        }
        .disposed(by: disposeBag)
    }
    
    //각 section의 footerView 설정
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
