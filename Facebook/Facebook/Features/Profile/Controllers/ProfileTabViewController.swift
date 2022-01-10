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
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<MultipleSectionModel>.ConfigureCell = { [weak self] dataSource, tableView, idxPath, _ in
        guard let self = self else { return UITableViewCell() }
        switch dataSource[idxPath] {
        case let .MainProfileItem(profileImageUrl, coverImageUrl, name, selfIntro, buttonText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainProfileCell", for: idxPath) as? MainProfileTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(profileImageUrl: profileImageUrl, coverImageUrl: coverImageUrl, name: name, selfIntro: selfIntro, buttonText: buttonText)
            
            if (self.userId == UserDefaultManager.cachedUser?.id) {
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
                
                cell.profileImage.rx
                    .tapGesture()
                    .when(.recognized)
                    .subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        self.imageType = "profile_image"
                        self.presentPicker()
                    }).disposed(by: cell.disposeBag)
            } else {
                cell.coverLabel.isHidden = true
                cell.coverImageButton.isHidden = true
            }
            
            
            return cell
        case let .SimpleInformationItem(style, informationType,image, information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(image: image, information: information)
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let detailProfileViewController = DetailProfileViewController(userId: self.userId)
                self.push(viewController: detailProfileViewController)
            }).disposed(by: cell.disposeBag)
            
            return cell
        case let .ButtonItem(style, buttonText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: idxPath) as? ButtonTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(buttonText: buttonText)
            
            cell.button.rx.tap.bind { [weak self] in
                let editProfileViewController = EditProfileViewController()
                self?.push(viewController: editProfileViewController)
            }.disposed(by: cell.disposeBag)
            
            return cell
        case let .CompanyItem(company):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style1)
            cell.configureCell(image: UIImage(systemName: "briefcase.fill") ?? UIImage(),
                               information: company.name ?? "")
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let detailProfileViewController = DetailProfileViewController(userId: self.userId)
                self.push(viewController: detailProfileViewController)
            }).disposed(by: cell.disposeBag)
            
            return cell
        case let .UniversityItem(university):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style1)
            cell.configureCell(image: UIImage(systemName: "graduationcap.fill") ?? UIImage(),
                               information: university.name ?? "")
            
            cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let detailProfileViewController = DetailProfileViewController(userId: self.userId)
                self.push(viewController: detailProfileViewController)
            }).disposed(by: cell.disposeBag)
            
            return cell
        case let .PostItem(post):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: idxPath) as? PostCell else { return UITableViewCell() }
            self.configure(cell: cell, with: post)
            return cell
        default:
            let cell = UITableViewCell()
            
            return cell 
        }
    }
    
    let sectionsBR: BehaviorRelay<[MultipleSectionModel]> = BehaviorRelay(value: [])
    
    var userProfile: UserProfile?
    let postDataViewModel: PaginationViewModel<Post>
    
    private var userId: Int
    private var imageType = "profile_image"
    
    init(userId: Int? = nil) {
        //자신의 프로필을 보는지, 다른 사람의 프로필을 보는 것인지
        if userId != nil { self.userId = userId! }
        else if UserDefaultManager.cachedUser != nil { self.userId = UserDefaultManager.cachedUser!.id }
        else { self.userId = 0 }

        postDataViewModel = PaginationViewModel<Post>(endpoint: .newsfeed(userId: self.userId))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userId == UserDefaultManager.cachedUser?.id {
            super.setNavigationBarItems(withEditButton: true)
        }else {
            super.setNavigationBarItems(withEditButton: false)
        }
        
        loadData()
        bind()
    }
    
    
    /// viewWillAppear로 매번 로딩하는 것보다
    /// RxSwift로 바인딩하는 방식이 바람직할 것 같습니다. (`StateManager` 사용)
    override func viewWillAppear(_ animated: Bool) {
        //제일 처음 로드되었을 때(userProfile == nil 일때)를 제외하고 화면이 보일 때 유저 프로필 데이터 리로드
//        if userProfile != nil {
//            loadData()
//        }
    }
    
    //유저 프로필 관련 데이터 불러오기
    func loadData() {
        NetworkService.get(endpoint: .profile(id: self.userId), as: UserProfile.self)
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
    
    func bind() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        print(self.userId)
        
        // 이게 최선인가?
        postDataViewModel.dataList.bind { [weak self] _ in
            self?.createSection()
        }.disposed(by: disposeBag)
        
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
                guard let self = self else { return }
                self.postDataViewModel.refresh()
            })
            .disposed(by: disposeBag)
        
        /// 새로고침이 완료될 때마다 `refreshControl`의 애니메이션을 중단시킵니다.
        postDataViewModel.refreshComplete
            .asDriver(onErrorJustReturn: false)
            .drive(onNext : { [weak self] refreshComplete in
                if refreshComplete {
                    self?.tabView.refreshControl.endRefreshing()
                    self?.loadData()
                }
            })
            .disposed(by: disposeBag)
        
        StateManager.of.post.bind(with: postDataViewModel.dataList).disposed(by: disposeBag)
        
        /// 테이블 맨 아래까지 스크롤할 때마다 `loadMore` 함수를 실행합니다.
        tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.tableView.contentOffset.y
            let contentHeight = self.tableView.contentSize.height
            
            if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                self.postDataViewModel.loadMore()
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
                .MainProfileItem(profileImageUrl: userProfile.profile_image ?? "" ,
                                 coverImageUrl: userProfile.cover_image ?? "",
                                 name: userProfile.username,
                                 selfIntro: userProfile.self_intro,
                                 buttonText: (userId == UserDefaultManager.cachedUser?.id) ? "프로필 편집" : "친구 추가")
            ])
        ]

        let companyItems = userProfile.company.map({ company in
            SectionItem.CompanyItem(company: company)
        })
        
        let universityItems = userProfile.university.map({ university in
            SectionItem.UniversityItem(university: university)
        })
        
        var otherItems: [SectionItem]
        
        if companyItems.count == 0 && universityItems.count == 0 {
            otherItems = [
                SectionItem.SimpleInformationItem(style: .style1,
                                                  image: UIImage(systemName: "briefcase.fill") ?? UIImage(),
                                                  information: "직장"),
                SectionItem.SimpleInformationItem(style: .style1,
                                                  image: UIImage(systemName: "graduationcap.fill") ?? UIImage(),
                                                  information: "학교"),
                SectionItem.SimpleInformationItem(style: .style1,
                                                  image: UIImage(systemName: "ellipsis") ?? UIImage(),
                                                  information: (userId == UserDefaultManager.cachedUser?.id)  ?
                                                  "내 정보 보기" : "\(userProfile.username ?? "회원")님의 정보 보기"),
                SectionItem.ButtonItem(style: .style1, buttonText: "전체 공개 정보 수정")
            ]
        } else {
            otherItems = [
                SectionItem.SimpleInformationItem(style: .style1,
                                                  image: UIImage(systemName: "ellipsis") ?? UIImage(),
                                                  information: (userId == UserDefaultManager.cachedUser?.id)  ?
                                                  "내 정보 보기" : "\(userProfile.username ?? "회원")님의 정보 보기"),
                SectionItem.ButtonItem(style: .style1, buttonText: "전체 공개 정보 수정")
            ]
        }
        
        //다른 사람 프로필일 경우 정보 수정 버튼 삭제
        if (userId != UserDefaultManager.cachedUser?.id) {
            otherItems.removeLast()
        }
        
        let detailSection: [MultipleSectionModel] = [
            .DetailInformationSection(title: "상세 정보",
                                      items: (companyItems+universityItems+otherItems))
        ]
        
        let postItems = postDataViewModel.dataList.value.map({ post in
            SectionItem.PostItem(post: post)
        }) ?? []
        
        let postSection: [MultipleSectionModel] = [
            .PostSection(title: "게시물",items: postItems)
        ]
        
        sectionsBR.accept(mainProfileSection + detailSection + postSection)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 2 { return UIView() }
        
        let headerView = UIView()
        
        let label: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.text = "게시물"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        if userId == UserDefaultManager.cachedUser?.id {
            let createHeaderView = CreatePostHeaderView()
            headerView.addSubview(label)
            headerView.addSubview(createHeaderView)
            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(equalToConstant: 20),
                label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                createHeaderView.topAnchor.constraint(equalTo: label.bottomAnchor),
                createHeaderView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
                createHeaderView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                createHeaderView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
            ])
            
            createHeaderView.createPostButton.rx.tap.bind { [weak self] _ in
                guard let self = self else { return }
                let createPostViewController = CreatePostViewController()
                let navigationController = UINavigationController(rootViewController: createPostViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        } else {
            headerView.addSubview(label)
            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(equalToConstant: 20),
                label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
            ])
        }
        
        headerView.backgroundColor = .white
        
        return headerView
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
        if section == 2 {
            if userId != UserDefaultManager.cachedUser?.id { return 40 }
            else { return 100 }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == sectionsBR.value.count - 1 { return 0 }
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
            .update(endpoint: .profile(id: self.userId, updateData: updateData))
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
                guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
                
                let uploadData = [self.imageType: imageData]  as [String : Any]
                
                NetworkService.update(endpoint: .profile(id: self.userId, updateData: uploadData)).subscribe { event in
                    let request = event.element
                    let progress = request?.uploadProgress
                    
                    request?.responseString(completionHandler: { data in
                        self.loadData()
                    })
                }.disposed(by: self.disposeBag)

            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
