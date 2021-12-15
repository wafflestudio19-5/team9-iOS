//
//  ProfileTabViewController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit
import Alamofire
import RxSwift
import RxAlamofire


class ProfileTabViewController: BaseTabViewController<ProfileTabView> {

    var tableView: UITableView {
        tabView.profileTableView
    }
    
    let dummyObservable = Observable.just(1...200)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setNavigationBarItems(withEditButton: true)
        bindTableView()
    }
    
    func bindTableView() {
        dummyObservable.bind(to: tableView.rx.items) { (tableView, row, item) -> UITableViewCell in
            if row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainProfileCell", for: IndexPath.init(row: row, section: 0)) as? MainProfileTableViewCell else { return UITableViewCell() }
                
                cell.delegate = self
                return cell
            }else if (row >= 1 && row <= 5){
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailProfileCell", for: IndexPath.init(row: row, section: 0))
                return cell
            }else if row == 6 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowProfileCell", for: IndexPath.init(row: row, section: 0)) as? ShowProfileTableViewCell else { return UITableViewCell() }
                
                cell.delegate = self
                return cell
            }else if row == 7{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell", for: IndexPath.init(row: row, section: 0)) as? EditProfileTableViewCell else { return UITableViewCell() }
                
                cell.delegate = self
                return cell
            }else if row == 8{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreatePostCell", for: IndexPath.init(row: row, section: 0)) as? CreatePostTableViewCell else { return UITableViewCell() }
                
                cell.delegate = self
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: IndexPath.init(row: row, section: 0))
                return cell
            }
        }.disposed(by: disposeBag)
    }
}

extension ProfileTabViewController: MainProfileTableViewCellDelegate,EditProfileTableViewCellDelegate {
    func goEditProfileView() {
        let editProfileViewController = EditProfileViewController()
        
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
}

extension ProfileTabViewController: ShowProfileTableViewCellDelegate {
    func goDetailProfileView() {
        let detailProfileViewController = DetailProfileViewController()
        
        self.navigationController?.pushViewController(detailProfileViewController, animated: true)
    }
}

extension ProfileTabViewController: CreatePostTableViewCellDelegate {
    func goCreatePostView() {
        let createPostViewController = CreatePostViewController()
        
        self.navigationController?.pushViewController(createPostViewController, animated: true)
    }
}
