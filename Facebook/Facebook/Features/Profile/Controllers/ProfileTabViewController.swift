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
        case let .MainProfileItem(profileImageUrl, coverImageUrl, name, selfIntro):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainProfileCell", for: idxPath) as? MainProfileTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(profileImageUrl: profileImageUrl, coverImageUrl: coverImageUrl, name: name, selfIntro: selfIntro)
            cell.configureEditButton(friendInfo: self.userProfile?.friend_info ?? "")
            self.bindMainCellAction(cell: cell, profileImageUrl: profileImageUrl, coverImageUrl: coverImageUrl, selfIntro: selfIntro)
            
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
        case let .FriendGridItem(friendsData):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCollectionTableViewCell.reuseIdentifier, for: idxPath) as? FriendCollectionTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(with: friendsData)
            
            cell.showFriendButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                let showFriendViewController = ShowFriendViewController(userId: self.userId)
                self.push(viewController: showFriendViewController)
            }.disposed(by: cell.refreshingBag)
            
            cell.friendGridCollectionView.rx.modelSelected(User.self)
                .subscribe (onNext: { [weak self] friend in
                    print(friend.id)
                    let profileTabVC = ProfileTabViewController(userId: friend.id)
                    self?.push(viewController: profileTabVC)
                }).disposed(by: cell.refreshingBag)
            
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
    var friendsNumber: Int?
    var friendsData: [User]?
    let postDataViewModel: PaginationViewModel<Post>
    
    private var userId: Int
    private lazy var imageType = "profile_image"
    
    init(userId: Int? = nil) {
        //자신의 프로필을 보는지, 다른 사람의 프로필을 보는 것인지
        if userId != nil {
            self.userId = userId!
        }
        else {
            self.userId = UserDefaultsManager.cachedUser?.id ?? 0
        }

        postDataViewModel = PaginationViewModel<Post>(endpoint: .newsfeed(userId: self.userId))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userId == UserDefaultsManager.cachedUser?.id {
            super.setNavigationBarItems(withEditButton: true)
        }else {
            super.setNavigationBarItems(withEditButton: false)
        }
        loadProfileData()
        bind()
        self.navigationItem.backButtonTitle = ""
        view.backgroundColor = .systemBackground
    }
    
    
    func bind() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        if self.userId == UserDefaultsManager.cachedUser?.id {
            StateManager.of.user
                .asObservable()
                .bind { [weak self] _ in
                    self?.createSection()
                }.disposed(by: disposeBag)
            
            StateManager.of.post.bind(with: postDataViewModel.dataList).disposed(by: disposeBag)
        }
        
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
                    self?.loadProfileData()
                }
            })
            .disposed(by: disposeBag)
        
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
        var userProfile: UserProfile
        if userId == UserDefaultsManager.cachedUser?.id {
            userProfile = StateManager.of.user.profile
        } else if self.userProfile != nil {
            userProfile = self.userProfile!
        } else {
            return
        }
        
        let mainProfileSection: [MultipleSectionModel] = [
            .ProfileImageSection(title: "메인 프로필", items: [
                .MainProfileItem(profileImageUrl: userProfile.profile_image ?? "" ,
                                 coverImageUrl: userProfile.cover_image ?? "",
                                 name: userProfile.username,
                                 selfIntro: userProfile.self_intro)
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
                                                  information: (userId == UserDefaultsManager.cachedUser?.id)  ?
                                                  "내 정보 보기" : "\(userProfile.username ?? "회원")님의 정보 보기"),
                SectionItem.ButtonItem(style: .style1, buttonText: "전체 공개 정보 수정")
            ]
        } else {
            otherItems = [
                SectionItem.SimpleInformationItem(style: .style1,
                                                  image: UIImage(systemName: "ellipsis") ?? UIImage(),
                                                  information: (userId == UserDefaultsManager.cachedUser?.id)  ?
                                                  "내 정보 보기" : "\(userProfile.username ?? "회원")님의 정보 보기"),
                SectionItem.ButtonItem(style: .style1, buttonText: "전체 공개 정보 수정")
            ]
        }
        //다른 사람 프로필일 경우 정보 수정 버튼 삭제
        if (userId != UserDefaultsManager.cachedUser?.id) {
            otherItems.removeLast()
        }
        let detailSection: [MultipleSectionModel] = [
            .DetailInformationSection(title: "상세 정보",
                                      items: (companyItems+universityItems+otherItems))
        ]
        
        let friendsData = friendsData ?? []
        let friendSection: [MultipleSectionModel] = [
            .FriendSection(title: "친구", items: [.FriendGridItem(friendsData: friendsData)])
        ]
        
        let postItems = postDataViewModel.dataList.value.map({ post in
            SectionItem.PostItem(post: post)
        })
        let postSection: [MultipleSectionModel] = [
            .PostSection(title: "게시물",items: postItems)
        ]
        
        sectionsBR.accept(mainProfileSection + detailSection + friendSection + postSection)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 2 && section != 3 { return UIView() }
        
        let headerView = UIView()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.text = dataSource[section].title
            
            return label
        }()
        
        switch section {
        case 2:
            let friendsNumberLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 18)
                label.text = "친구 " + String(self.friendsNumber ?? 0) + "명"
                label.textColor = .gray
                
                return label
            }()
            
            let sectionButton: UIButton = {
                let button = UIButton()
                button.setTitle("친구 찾기", for: .normal)
                button.setTitleColor(UIColor.systemBlue, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                
                return button
            }()
            
            headerView.addSubview(titleLabel)
            headerView.addSubview(friendsNumberLabel)
            headerView.addSubview(sectionButton)
            titleLabel.snp.makeConstraints { make in
                make.height.equalTo(20)
                make.top.equalToSuperview().inset(10)
                make.leading.equalToSuperview().inset(15)
            }
            friendsNumberLabel.snp.makeConstraints { make in
                make.height.equalTo(20)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.leading.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(5)
            }
            sectionButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(15)
            }
            sectionButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                let showFriendViewController = ShowFriendViewController(userId: self.userId)
                self.push(viewController: showFriendViewController)
            }.disposed(by: self.disposeBag)
        case 3:
            if userId == UserDefaultsManager.cachedUser?.id {
                let createHeaderView = CreatePostHeaderView()
                headerView.addSubview(titleLabel)
                headerView.addSubview(createHeaderView)
                titleLabel.snp.makeConstraints { make in
                    make.height.equalTo(20)
                    make.top.equalToSuperview().inset(10)
                    make.leading.equalToSuperview().inset(15)
                }
                createHeaderView.snp.makeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom)
                    make.bottom.leading.trailing.equalToSuperview()
                }
                
                createHeaderView.createPostButton.rx.tap.bind { [weak self] _ in
                    guard let self = self else { return }
                    let createPostViewController = CreatePostViewController()
                    let navigationController = UINavigationController(rootViewController: createPostViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: nil)
                }.disposed(by: disposeBag)
            } else {
                headerView.addSubview(titleLabel)
                titleLabel.snp.makeConstraints { make in
                    make.height.equalTo(20)
                    make.top.bottom.equalToSuperview().inset(10)
                    make.leading.equalToSuperview().inset(15)
                }
            }
        default:
            break
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
        switch section {
        case 2:
            return 60
        case 3:
            if userId != UserDefaultsManager.cachedUser?.id { return 40 }
            else { return 100 }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == sectionsBR.value.count - 1 { return 0 }
        return 5
    }
}

extension ProfileTabViewController {
    //자기 소개가 이미 있을 때 자기 소개 관련 메뉴(alertsheet형식) present
    func showAlertSelfIntroMenu() {
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
    
    func showAlertImageMenu() {
        let alertMenu = UIAlertController(title: self.imageType == "profile_image" ?
                                          "프로필 사진 수정" : "커버 사진 수정",
                                          message: "",
                                          preferredStyle: .actionSheet)
        
        let editSelfIntroAction = UIAlertAction(title: self.imageType == "profile_image" ?
                                                "프로필 사진 변경" : "커버 사진 변경",
                                                style: .default,
                                                handler: { action in
                                                    self.presentPicker()
                                                })
        editSelfIntroAction.setValue(0, forKey: "titleTextAlignment")
        editSelfIntroAction.setValue(UIImage(systemName: "photo.on.rectangle.angled")!, forKey: "image")
        
        let deleteSelfIntroAction = UIAlertAction(title: self.imageType == "profile_image" ?
                                                  "프로필 사진 삭제" : "커버 사진 삭제",
                                                  style: .default,
                                                  handler: { action in
                                                      self.deleteImage()
                                                  })
        deleteSelfIntroAction.setValue(0, forKey: "titleTextAlignment")
        deleteSelfIntroAction.setValue(UIImage(systemName: "trash.circle")!, forKey: "image")
        
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alertMenu.addAction(editSelfIntroAction)
        alertMenu.addAction(deleteSelfIntroAction)
        alertMenu.addAction(cancelAction)
        
        self.present(alertMenu, animated: true, completion: nil)
    }
    
    func showAlertFriendMenu() {
        let alertMenu = UIAlertController(title: "친구 관리", message: "", preferredStyle: .actionSheet)
        
        let deleteFriendAction = UIAlertAction(title: "친구 끊기", style: .default, handler: { action in
            self.deleleFriend()
        })
        deleteFriendAction.setValue(0, forKey: "titleTextAlignment")
        deleteFriendAction.setValue(UIImage(systemName: "person.fill.xmark")!, forKey: "image")
        
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alertMenu.addAction(deleteFriendAction)
        alertMenu.addAction(cancelAction)
        
        self.present(alertMenu, animated: true, completion: nil)
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
                
                    request?.responseDecodable(of: UserProfile.self) { dataResponse in
                        guard let userProfile = dataResponse.value else { return }
                        StateManager.of.user.dispatch(profile: userProfile)
                    }
                }.disposed(by: self.disposeBag)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}


extension ProfileTabViewController {
    func bindMainCellAction(cell: MainProfileTableViewCell, profileImageUrl: String, coverImageUrl: String, selfIntro: String) {
        if (self.userId == UserDefaultsManager.cachedUser?.id) {
            //자기 자신의 프로필을 볼 때
            //커버 이미지
            if coverImageUrl != "" {
                cell.coverImage.rx
                    .tapGesture()
                    .when(.recognized)
                    .subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        self.imageType = "cover_image"
                        if coverImageUrl != "" {
                            self.showAlertImageMenu()
                        } else {
                            self.presentPicker()
                        }
                    }).disposed(by: cell.disposeBag)
                cell.coverLabel.isHidden = true
                cell.coverImageButton.isHidden = true
            } else {
                cell.coverImageButton.rx
                    .tap
                    .bind { [weak self] in
                        guard let self = self else { return }
                        self.imageType = "cover_image"
                        self.presentPicker()
                    }.disposed(by: cell.disposeBag)
                cell.coverLabel.isHidden = false
                cell.coverImageButton.isHidden = false
            }
            
            //프로필 이미지
            cell.profileImage.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.imageType = "profile_image"
                    if profileImageUrl != "" {
                        self.showAlertImageMenu()
                    } else {
                        self.presentPicker()
                    }
                }).disposed(by: cell.disposeBag)
            
            //자기소개 관련 동작
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
                        self?.showAlertSelfIntroMenu()
                    }
                }).disposed(by: cell.disposeBag)
        } else {
            cell.coverLabel.isHidden = true
            cell.coverImageButton.isHidden = true
        }
        
        guard let friendInfo = userProfile?.friend_info else { return }
        
        //프로필 편집 버튼
        cell.editProfileButton.rx
            .tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                switch friendInfo {
                case "self":
                    let editProfileViewController = EditProfileViewController()
                    self.push(viewController: editProfileViewController)
                case "friend":
                    self.showAlertFriendMenu()
                case "sent":
                    self.deleteFriendRequest()
                case "received":
                    self.acceptFriendRequest()
                case "nothing":
                    self.friendRequest()
                default:
                    let editProfileViewController = EditProfileViewController()
                    self.push(viewController: editProfileViewController)
                }
            }.disposed(by: cell.disposeBag)
    }
}

//네트워크 관련 extension
extension ProfileTabViewController {
    //유저 프로필 관련 데이터 불러오기
    func loadProfileData() {
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
                
                self.title = response.username
                if self.userId == UserDefaultsManager.cachedUser?.id {
                    StateManager.of.user.dispatch(profile: response)
                    self.loadFriendData()
                } else {
                    self.userProfile = response
                    self.loadFriendData()
                }
            }.disposed(by: disposeBag)
    }
    
    func loadFriendData() {
        NetworkService.get(endpoint: .friend(id: self.userId, limit: 6), as: PaginatedResponse<User>.self)
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

                self.friendsNumber = response.count
                self.friendsData = response.results
                self.createSection()
            }.disposed(by: disposeBag)
    }
    
    //자기소개 삭제
    func deleteSelfIntro() {
        let updateData = ["self_intro": ""]
        
        NetworkService
            .update(endpoint: .profile(id: self.userId, updateData: updateData))
            .subscribe { event in
                let request = event.element
            
                request?.responseDecodable(of: UserProfile.self) { dataResponse in
                    guard let userProfile = dataResponse.value else { return }
                    StateManager.of.user.dispatch(profile: userProfile)
                }
            }.disposed(by: self.disposeBag)
    }
    
    //친구 삭제
    func deleleFriend() {
        let alert = UIAlertController(title: (userProfile?.username ?? "이 친구") + "님을 친구에서 삭제하시겠어요?", message: "",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        let deleteAction = UIAlertAction(title: "확인", style: .default) { action in
            NetworkService.delete(endpoint: .friend(friendId: self.userId))
                .subscribe { [weak self] event in
                    guard let self = self else { return }
                    if event.isCompleted {
                        return
                    }
                    
                    if !(event.element is NSNull) {
                        self.alert(title: "친구 삭제 오류", message: "친구 삭제 중 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                    } else {
                        self.userProfile?.friend_info = "nothing"
                        self.createSection()
                    }
                }.disposed(by: self.disposeBag)
        }
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //프로필 관련 이미지 삭제
    func deleteImage() {
        var updateData: [String: Bool]
        
        if self.imageType == "profile_image" {
            updateData = ["profile_image": true, "cover_image": false]
        } else {
            updateData = ["profile_image": false, "cover_image": true]
        }
        
        NetworkService.delete(endpoint: .image(id: self.userId, updateData: updateData), as: UserProfile.self)
            .subscribe { event in
                if event.isCompleted {
                    return
                }
            
                guard let response = event.element?.1 else {
                    print("데이터 로드 중 오류 발생")
                    print(event)
                    return
                }
                
                StateManager.of.user.dispatch(profile: response)
            }.disposed(by: self.disposeBag)
    }
    
    //친구 요청
    func friendRequest() {
        NetworkService.post(endpoint: .friendRequest(id: self.userId), as: FriendRequestCreate.self)
            .subscribe { [weak self] event in
                guard let self = self else { return }
                
                if event.isCompleted {
                    return
                }
                
                if event.element?.1 == nil {
                    self.alert(title: "친구 요청 오류", message: "요청 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                } else {
                    self.userProfile?.friend_info = "sent"
                    self.createSection()
                }
            }.disposed(by: self.disposeBag)
    }
    
    func acceptFriendRequest() {
        NetworkService.put(endpoint: .friendRequest(id: self.userId))
            .subscribe { [weak self] event in
                guard let self = self else { return }
                
                if event.isCompleted {
                    return
                }
                
                if event.element as? String != "수락 완료되었습니다." {
                    self.alert(title: "친구 요청 수락 오류", message: "요청을 수락하던 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                } else {
                    self.userProfile?.friend_info = "friend"
                    self.createSection()
                }
            }.disposed(by: self.disposeBag)
    }
    
    func deleteFriendRequest() {
        NetworkService.delete(endpoint: .friendRequest(id: self.userId))
            .subscribe{ [weak self] event in
                guard let self = self else { return }
                
                if event.isCompleted {
                    return
                }
                
                if !(event.element is NSNull) {
                    self.alert(title: "친구 요청 취소 오류", message: "요청을 취소하던 도중에 에러가 발생했습니다. 다시 시도해주시기 바랍니다.", action: "확인")
                } else {
                    self.userProfile?.friend_info = "nothing"
                    self.createSection()
                }
            }.disposed(by: self.disposeBag)
    }
}
