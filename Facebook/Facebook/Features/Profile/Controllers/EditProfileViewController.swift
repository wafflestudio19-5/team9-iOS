//
//  EditProfileViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/14.
//

import UIKit
import PhotosUI
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
        case let .ImageItem(style, imageUrl):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: idxPath) as? ImageTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(cellStyle: style, imageUrl: imageUrl)
            
            cell.imgView.rx
                .tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    switch style {
                    case .profileImage:
                        self.imageType = "profile_image"
                    case .coverImage:
                        self.imageType = "cover_image"
                    }
                    if imageUrl != "" {
                        self.showAlertImageMenu()
                    } else {
                        self.presentPicker()
                    }
                }).disposed(by: cell.disposeBag)
            
            return cell
        case let .SimpleInformationItem(style, informationType, image, information):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(image: image, information: information)
            
            cell.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    let editDetailInformationViewController = EditDetailInformationViewController()
                    self?.push(viewController: editDetailInformationViewController)
                }).disposed(by: cell.disposeBag)
            
            return cell
        case let .LabelItem(style, labelText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.reuseIdentifier, for: idxPath) as? LabelTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(labelText: labelText)
            
            cell.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig).when(.recognized).subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    
                    if (labelText == "회원님에 대해 설명해주세요...") {
                        let addSelfIntroViewController = AddSelfIntroViewController()
                        let navigationController = UINavigationController(rootViewController: addSelfIntroViewController)
                        navigationController.modalPresentationStyle = .fullScreen
                        self.present(navigationController, animated: true, completion: nil)
                    } else {
                        self.showAlertSelfIntroMenu()
                    }
                }).disposed(by: cell.disposeBag)
            
            return cell
        case let .CompanyItem(company):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style1)
            cell.configureCell(image: UIImage(systemName: "briefcase") ?? UIImage(),
                               information: company.name ?? "")
            
            cell.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    let editDetailInformationViewController = EditDetailInformationViewController()
                    self?.push(viewController: editDetailInformationViewController)
                }).disposed(by: cell.disposeBag)

            
            return cell
        case let .UniversityItem(university):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleInformationTableViewCell.reuseIdentifier, for: idxPath) as? SimpleInformationTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: .style1)
            cell.configureCell(image: UIImage(systemName: "graduationcap") ?? UIImage(),
                               information: university.name ?? "")
            
            cell.rx.tapGesture(configuration: TapGestureConfigurations.scrollViewTapConfig)
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    let editDetailInformationViewController = EditDetailInformationViewController()
                    self?.push(viewController: editDetailInformationViewController)
                }).disposed(by: cell.disposeBag)
            
            return cell
        case let .ButtonItem(style, buttonText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: idxPath) as? ButtonTableViewCell else { return UITableViewCell() }
            
            cell.initialSetup(cellStyle: style)
            cell.configureCell(buttonText: buttonText)
            
            cell.button.rx.tap.bind { [weak self] in
                let detailProfileViewController = DetailProfileViewController(userId: UserDefaultsManager.cachedUser?.id ?? 0)
                self?.push(viewController: detailProfileViewController)
            }.disposed(by: cell.disposeBag)
            
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    private var imageType = "profile_image"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "프로필 편집"
        setNavigationItem()
        createSection()
        bind()
    }
    
    private func setNavigationItem() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func createSection() {
        let userProfile = StateManager.of.user.profile
        
        var companyItems = userProfile.company.map({ company in
            SectionItem.CompanyItem(company: company)
        })
        
        var universityItems = userProfile.university.map({ university in
            SectionItem.UniversityItem(university: university)
        })
        
        if companyItems.count == 0 {
            companyItems = [ .SimpleInformationItem(style: .style2,
                                                    image: UIImage(systemName: "briefcase") ?? UIImage(),
                                                    information: "직장") ]
        }
        
        if universityItems.count == 0 {
            universityItems = [ .SimpleInformationItem(style: .style2,
                                                      image: UIImage(systemName: "graduationcap") ?? UIImage(),
                                                      information: "학력") ]
        }
        
        let sections: [MultipleSectionModel] = [
            .ProfileImageSection(title: "프로필 사진", items: [
                .ImageItem(style: .profileImage, imageUrl: userProfile.profile_image ?? "")
            ]),
            .CoverImageSection(title: "커버 사진", items: [
                .ImageItem(style: .coverImage, imageUrl: userProfile.cover_image ?? "")
            ]),
            .SelfIntroSection(title: "소개", items: [
                .LabelItem(style: .style1, labelText: (userProfile.self_intro != "" ? userProfile.self_intro : "회원님에 대해 설명해주세요..."))
            ]),
            .DetailInformationSection(title: "상세 정보", items: companyItems + universityItems),
            .EditProfileSection(title: "정보 수정", items: [
                .ButtonItem(style: .style2, buttonText: "정보 수정")
            ])
        ]
        
        sectionsBR.accept(sections)
    }
    
    func bind() {
        sectionsBR.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        StateManager.of.user
            .asObservable()
            .bind { [weak self] _ in
                self?.createSection()
            }.disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    //UITableView의 custom header적용
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if section == (sectionsBR.value.count - 1) { return UIView() } //마지막 section header 제거
        
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
            sectionButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                self.imageType = "profile_image"
                if StateManager.of.user.profile.profile_image != nil {
                    self.showAlertImageMenu()
                } else {
                    self.presentPicker()
                }
            }.disposed(by: disposeBag)
        case 1:
            sectionButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                self.imageType = "cover_image"
                if StateManager.of.user.profile.cover_image != nil {
                    self.showAlertImageMenu()
                } else {
                    self.presentPicker()
                }
            }.disposed(by: disposeBag)
        case 2:
            sectionButton.rx.tap.bind { [weak self] in
                guard let self = self else { return }
                if (StateManager.of.user.profile.self_intro == "") {
                    let addSelfIntroViewController = AddSelfIntroViewController()
                    let navigationController = UINavigationController(rootViewController: addSelfIntroViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: nil)
                } else {
                    self.showAlertSelfIntroMenu()
                }
            }.disposed(by: disposeBag)
        case 3:
            sectionButton.rx.tap.bind { [weak self] in
                let editDetailInformationViewController = EditDetailInformationViewController()
                self?.push(viewController: editDetailInformationViewController)
            }.disposed(by: disposeBag)
        default: break
        }
    
        return headerView
    }
    
    //footer의 separate line
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == (sectionsBR.value.count - 1)  { return UIView() } //마지막 section separator line 젝
        
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
        if section == (sectionsBR.value.count - 1)  { return 0 } //마지막 section header w제거
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == sectionsBR.value.count - 1 { return 0 }
        return 5
    }
}

extension EditProfileViewController {
    //자기 소개가 이미 있을 때 자기 소개 관련 메뉴(alertsheet형식) present
    func showAlertSelfIntroMenu() {
        let menuList = [ Menu(image: UIImage(systemName: "pencil.and.outline") ?? UIImage(),
                              text: "소개 수정", action: {
            let addSelfIntroViewController = AddSelfIntroViewController()
            let navigationController = UINavigationController(rootViewController: addSelfIntroViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }),
                         Menu(image: UIImage(systemName: "trash.fill") ?? UIImage(),
                              text: "소개 삭제", action: {
            self.deleteSelfIntro()
        })]
        
        let bottomSheetVC = BottomSheetViewController(menuList: menuList)
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    func deleteSelfIntro() {
        let updateData = ["self_intro": ""]
        
        NetworkService
            .update(endpoint: .profile(id: UserDefaultsManager.cachedUser?.id ?? 0, updateData: updateData))
            .subscribe { event in
                let request = event.element
            
                request?.responseDecodable(of: UserProfile.self) { dataResponse in
                    guard let userProfile = dataResponse.value else { return }
                    StateManager.of.user.dispatch(profile: userProfile)
                }
            }.disposed(by: self.disposeBag)
    }
    
    func showAlertImageMenu() {
        let menuList = [ Menu(image: UIImage(systemName: "photo.on.rectangle.angled") ?? UIImage(),
                              text: self.imageType == "profile_image" ?
                              "프로필 사진 변경" : "커버 사진 변경", action: {
            self.presentPicker()
        }),
                         Menu(image: UIImage(systemName: "trash.fill") ?? UIImage(),
                              text: self.imageType == "profile_image" ?
                              "프로필 사진 삭제" : "커버 사진 삭제", action: {
            self.deleteImage()
        })]
        
        let bottomSheetVC = BottomSheetViewController(menuList: menuList)
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    func deleteImage() {
        var updateData: [String: Bool]
        
        if self.imageType == "profile_image" {
            updateData = ["profile_image": true, "cover_image": false]
        } else {
            updateData = ["profile_image": false, "cover_image": true]
        }
        
        NetworkService.delete(endpoint: .image(id: UserDefaultsManager.cachedUser?.id ?? 0, updateData: updateData), as: UserProfile.self)
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
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    
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
                
                NetworkService
                    .update(endpoint: .profile(id: UserDefaultsManager.cachedUser?.id ?? 0, updateData: uploadData))
                    .subscribe { event in
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

