//
//  RootTabBarController.swift
//  Facebook
//
//  Created by 최유림 on 2021/11/24.
//

import UIKit

class RootTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .darkGray
        
        self.view.backgroundColor = .white
        self.view.tintColor = .darkGray
        self.navigationItem.backButtonTitle = ""
        
        setTabBarController()
    }
    
    private func setTabBarController() {
        let controllers = [newsfeedNavController,
                           profileNavController,
                           notificationNavController]
        
        self.viewControllers = controllers
        self.tabBar.backgroundColor = UIColor.white
    }
    
    lazy var newsfeedNavController: UINavigationController = {
        let newsfeedTabViewController = UINavigationController(rootViewController: NewsfeedTabViewController())
        let newsfeedTabViewIcon = UITabBarItem(title: "뉴스피드", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        newsfeedTabViewController.tabBarItem = newsfeedTabViewIcon
        return newsfeedTabViewController
    }()
    
    lazy var profileNavController: UINavigationController = {
        let profileTabViewController = UINavigationController(rootViewController: ProfileTabViewController())
        let profileTabViewIcon = UITabBarItem(title: "프로필", image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        profileTabViewController.tabBarItem = profileTabViewIcon
        return profileTabViewController
    }()
    
    lazy var notificationNavController: UINavigationController = {
        let notificationTabViewController = UINavigationController(rootViewController: NotificationTabViewController())
        let notificationTabViewIcon = UITabBarItem(title: "알림", image: UIImage(systemName: "bell"), selectedImage: UIImage(systemName: "bell.fill"))
        notificationTabViewController.tabBarItem = notificationTabViewIcon
        return notificationTabViewController
    }()
}
