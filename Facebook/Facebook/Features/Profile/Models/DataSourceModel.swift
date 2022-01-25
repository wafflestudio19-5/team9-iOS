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
    case FriendSection(title: String, items: [SectionItem])
    case PostSection(title: String, items: [SectionItem])
}

enum SectionItem {
    case MainProfileItem(profileImageUrl: String, coverImageUrl: String, name: String, selfIntro: String)
    case ImageItem(style: ImageTableViewCell.Style, imageUrl: String)
    case SimpleInformationItem(style: SimpleInformationTableViewCell.Style,
                               informationType: AddInformationViewController<AddInformationView>.InformationType? = nil,
                               image: UIImage,
                               information: String)
    case DetailInformationItem(style: DetailInformationTableViewCell.Style,
                               image: UIImage,
                               information: String,
                               time: String = "",
                               description: String = "",
                               privacyBound: String = "")
    case AddInformationWithImageItem(style: SelectInformationViewController<SelectInformationView>.InformationType,
                                     image: UIImage,
                                     information: String)
    case AddInfomrationLabelItem(style: SelectInformationViewController<SelectInformationView>.InformationType,
                                 information: String)
    case AddInformationButtonItem(style: AddInformationViewController<AddInformationView>.InformationType, buttonText: String)
    case ButtonItem(style: ButtonTableViewCell.Style, buttonText: String)
    case LabelItem(style: LabelTableViewCell.Style, labelText: String)
    case TextFieldItem(text: String)
    case CompanyItem(company: Company)
    case UniversityItem(university: University)
    case PostItem(post: Post)
    case SelectDateItem(style: DateSelectTableViewCell.Style, dateInfo: String)
    case BirthSelectItem(style: BirthSelectTableViewCell.Style, birthInfo: String)
    case EditUsernameItem(username: String)
    case GenderSelectItem(style: GenderSelectTableViewCell.Style, selectedGender: String)
    case FriendGridItem(friendsData: [User])
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
        case .FriendSection(title: _, items: let items):
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
        case let .FriendSection(title: title, items: items):
            self = .FriendSection(title: title, items: items)
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
        case .FriendSection(title: let title, items: _):
            return title
        case .PostSection(title: let title, items: _):
            return title
        }
    }
}

