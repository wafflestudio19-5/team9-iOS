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

class ProfileTabViewController: BaseTabViewController<ProfileTabView> {

    var tableView: UITableView {
        tabView.profileTableView
    }
    
    let dummyObservable = Observable.just(1...15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setNavigationBarItems(withEditButton: true)
        
        bindTableView()
    }
    
    func bindTableView() {
        dummyObservable.bind(to: tableView.rx.items) { (tableView, row, item) -> UITableViewCell in
            if row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainProfileCell", for: IndexPath.init(row: row, section: 0)) as? MainProfileTableViewCell else { return UITableViewCell() }
                
                cell.editProfileButton.rx.tap.bind { [weak self] _ in
                    let editProfileViewController = EditProfileViewController()
                    self?.push(viewController: editProfileViewController)
                }.disposed(by: self.disposeBag)
                return cell
            }else if (row >= 1 && row <= 5){
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailProfileCell", for: IndexPath.init(row: row - 1, section: 1))
                
                cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                    let detailProfileViewController = DetailProfileViewController()
                    self?.push(viewController: detailProfileViewController)
                }).disposed(by: self.disposeBag)
                return cell
            }else if row == 6 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowProfileCell", for: IndexPath.init(row: row - 1, section: 1)) as? ShowProfileTableViewCell else { return UITableViewCell() }
                
                cell.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                    let detailProfileViewController = DetailProfileViewController()
                    self?.push(viewController: detailProfileViewController)
                }).disposed(by: self.disposeBag)
                return cell
            }else if row == 7{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell", for: IndexPath.init(row: row - 1, section: 1)) as? EditProfileTableViewCell else { return UITableViewCell() }
                
                cell.editProfileButton.rx.tap.bind { [weak self] _ in
                    let editProfileViewController = EditProfileViewController()
                    self?.push(viewController: editProfileViewController)
                }.disposed(by: self.disposeBag)
                return cell
            }else if row == 8{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreatePostCell", for: IndexPath.init(row: row - 8, section: 2)) as? CreatePostTableViewCell else { return UITableViewCell() }
                
                
                return cell
            }else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: IndexPath.init(row: row - 9, section: 3)) as? PostTableViewCell else { return UITableViewCell() }
                
                
                return cell
            }
        }.disposed(by: disposeBag)
    }
}
