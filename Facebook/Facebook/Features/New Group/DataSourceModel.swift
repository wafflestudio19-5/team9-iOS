//
//  DataSourceModel.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/22.
//

import Foundation
import RxDataSources
import UIKit

enum MultipleSectionModel {
    case ProfileImageSection(title: String, items: [SectionItem])
    case CoverImageSection(title: String, items: [SectionItem])
    case SelfIntroSection(title: String, items: [SectionItem])
    case DetailInformationSection(title: String, items: [SectionItem])
    case EditProfileSection(title: String, items: [SectionItem])
    case PostSection(title: String, items: [SectionItem])
}

enum SectionItem {
    case MainProfileItem(profileImage: UIImage, coverImage: UIImage, name: String)
    case ProfileImageItem(image: UIImage)
    case CoverImageItem(image: UIImage)
    case SelfIntroItem(intro: String)
    case DetailInformationItem(image: UIImage, information: String)
    case EditProfileItem(title: String)
    case PostItem(post: Post)
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
        case .PostSection(title: _, items: let items):
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
        case let .PostSection(title: title, items: _):
            self = .PostSection(title: title, items: items)
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
        case .PostSection(title: let title, items: _):
            return title
        }
    }
}

struct DataSourceModel {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<MultipleSectionModel>{
        return RxTableViewSectionedReloadDataSource<MultipleSectionModel>(
            configureCell: { dataSource, tableView, idxPath, _ in
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
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelfIntroCell", for: idxPath) as? SelfIntroTableViewCell else { return UITableViewCell() }
                    
                    cell.selfIntroLabel.text = intro
                    return cell
                case let .DetailInformationItem(image,information):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailProfileCell", for: idxPath) as? DetailProfileTableViewCell else { return UITableViewCell() }
                    
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
                }
            }
        )
    }
}
