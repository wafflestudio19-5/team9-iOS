//
//  ProfileTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit
import PhotosUI
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources

class ProfileTabViewController: BaseTabViewController<ProfileTabView>, UITableViewDelegate {

    var tableView: UITableView {
        tabView.profileTableView
    }
    
    //TableView 바인딩을 위한 dataSource객체
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: configureCell)
    
    //enum SectionItem의 유형에 따라 다른 cell type을 연결
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { dataSource, tableView, idxPath, _ in
        switch dataSource[idxPath] {
        case let .MainProfileItem(profileImageUrl, coverImageUrl, name, selfIntro):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainProfileCell", for: idxPath) as? MainProfileTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(profileImageUrl: profileImageUrl, coverImageUrl: coverImageUrl, name: name, selfIntro: selfIntro)
            
            cell.profileImage.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.imageType = "profile_image"
                    self.presentPicker()
                }).disposed(by: cell.disposeBag)
            
            if coverImageUrl != "" {
                cell.coverImage.rx
                    .tapGesture()
                    .when(.recognized)
                    .subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        self.imageType = "cover_image"
                        self.presentPicker()
                    }).disposed(by: cell.disposeBag)
            } else {
                cell.coverImageButton.rx
                    .tap
                    .bind { [weak self] in
                        guard let self = self else { return }
                        self.imageType = "cover_image"
                        self.presentPicker()
                    }.disposed(by: cell.disposeBag)
            }
            
            
            cell.selfIntroLabel.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    if selfIntro == "" {
                        let addSelfIntroViewController = AddSelfIntroViewController()
                        let navigationController = UINavigationController(rootViewController: addSelfIntroViewController)
                        navigationController.modalPresentationStyle = .fullScreen
                        self?.present(navigationController, animated: true, completion: nil)
                    } else {
                        self?.showAlertMenu()
                    }
                }).disposed(by: cell.disposeBag)
            
            cell.editProfileButton.rx
                .tap
                .bind { [weak self] in
                    let editProfileViewController = EditProfileViewController()
                    self?.push(viewController: editProfileViewController)
                }.disposed(by: cell.disposeBag)
            
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
        case let .CompanyItem(company):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style1)
            cell.configureCell(image: UIImage(systemName: "briefcase.fill")!, information: company.name ?? "")
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                let detailProfileViewController = DetailProfileViewController()
                self?.push(viewController: detailProfileViewController)
            }).disposed(by: self.disposeBag)
            
            return cell
        case let .UniversityItem(university):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style1)
            cell.configureCell(image: UIImage(systemName: "graduationcap.fill")!, information: university.name ?? "")
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                let detailProfileViewController = DetailProfileViewController()
                self?.push(viewController: detailProfileViewController)
            }).disposed(by: self.disposeBag)
            
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
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay(value: [])
    
    var userProfile: UserProfile?
    var postDataViewModel: PaginationViewModel<Post>?
    //let postDataViewModel = PaginationViewModel<Post>(endpoint: .newsfeed(id: 41))
    
    private var imageType = "profile_image"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setNavigationBarItems(withEditButton: true)
        
        loadData()
        bind()
    }
    
    
    //유저 프로필 관련 데이터 불러오기
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
        }.disposed(by: disposeBag)
        
        postDataViewModel = PaginationViewModel<Post>(endpoint: .newsfeed())
    }
    
    func bind() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        guard let postDataViewModel = postDataViewModel else { return }
        
        /// `isLoading` 값이 바뀔 때마다 하단 스피너를 토글합니다.
        postDataViewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.tabView.showBottomSpinner()
                } else {
                    self?.tabView.hideBottomSpinner()
                    self?.createSection()
                }
            })
            .disposed(by: disposeBag)
        
        /// 새로고침 제스쳐가 인식될 때마다 `refresh` 함수를 실행합니다.
        tabView.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                postDataViewModel.refresh()
                self?.createSection()
            })
            .disposed(by: disposeBag)
        
        /// 새로고침이 완료될 때마다 `refreshControl`의 애니메이션을 중단시킵니다.
        postDataViewModel.refreshComplete
            .asDriver(onErrorJustReturn: false)
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
                postDataViewModel.loadMore()
            }
        }
        .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    //불러온 데이터에 따라 sectionModel 생성
    func createSection() {
        guard let userProfile = userProfile else { return }
        
        let mainProfileSection: [MultipleSectionModel] = [
            .ProfileImageSection(title: "메인 프로필", items: [
                .MainProfileItem(
                    profileImageUrl: userProfile.profile_image ?? "" ,
                    coverImageUrl: userProfile.cover_image ?? "",
                    name: userProfile.username ?? "username",
                    selfIntro: userProfile.self_intro ?? "")
            ])
        ]

        let companyItems = userProfile.company?.map({ company in
            SectionItem.CompanyItem(company: company)
        }) ?? []
        
        let universityItems = userProfile.university?.map({ university in
            SectionItem.UniversityItem(university: university)
        }) ?? []
        
        let otherItems = [
            SectionItem.SimpleInformationItem(style: .style1, image: UIImage(systemName: "ellipsis")!, information: "내 정보 보기"),
            SectionItem.ButtonItem(style: .style1, buttonText: "전체 공개 정보 수정")
        ]
        
        let detailSection: [MultipleSectionModel] = [
            .DetailInformationSection(title: "상세 정보",
                                      items: (companyItems+universityItems+otherItems))
        ]
        
        let postItems = postDataViewModel?.dataList.value.map({ post in
            SectionItem.PostItem(post: post)
        }) ?? []
        
        let postSection: [MultipleSectionModel] = [
            .PostSection(title: "내가 쓴 글",items: postItems)
        ]
        
        sectionsBR.accept(mainProfileSection + detailSection + postSection)
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

extension ProfileTabViewController {
    //자기 소개가 이미 있을 때 자기 소개 관련 메뉴(alertsheet형식) present
    func showAlertMenu() {
        let alertMenu = UIAlertController(title: "자기 소개", message: "", preferredStyle: .actionSheet)
        
        let editSelfIntroAction = UIAlertAction(title: "소개 수정", style: .default, handler: { action in
            let addSelfIntroViewController = AddSelfIntroViewController()
            let navigationController = UINavigationController(rootViewController: addSelfIntroViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        })
        editSelfIntroAction.setValue(0, forKey: "titleTextAlignment")
        editSelfIntroAction.setValue(UIImage(systemName: "pencil.circle")!, forKey: "image")
        
        let deleteSelfIntroAction = UIAlertAction(title: "소개 삭제", style: .default, handler: { action in
            self.deleteSelfIntro()
        })
        deleteSelfIntroAction.setValue(0, forKey: "titleTextAlignment")
        deleteSelfIntroAction.setValue(UIImage(systemName: "trash.circle")!, forKey: "image")
        
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alertMenu.addAction(editSelfIntroAction)
        alertMenu.addAction(deleteSelfIntroAction)
        alertMenu.addAction(cancelAction)
        
        self.present(alertMenu, animated: true, completion: nil)
    }
    
    func deleteSelfIntro() {
        let updateData = ["self_intro": ""]
        
        NetworkService
            .update(endpoint: .profile(id: 41, updateData: updateData))
            .subscribe{ [weak self] _ in
                self?.loadData()
            }.disposed(by: disposeBag)
    }
}

extension ProfileTabViewController: PHPickerViewControllerDelegate {
    
    private func presentPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        configuration.preferredAssetRepresentationMode = .current
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // itemProvider 를 가져온다.
        if let result = results.first{
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                guard let image = image as? UIImage else { return }
                guard let imageData = image.pngData() else { return }
                
                let uploadData = ["self_intro": "테스트 자기소개", self.imageType: imageData]  as [String : Any]
                
                NetworkService.update(endpoint: .profile(id: 41, updateData: uploadData)).subscribe(onNext: { event in
                    print(event)
                    print("upload complete!")
                }).disposed(by: self.disposeBag)

            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
