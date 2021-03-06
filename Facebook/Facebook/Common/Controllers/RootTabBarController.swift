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
        
        self.view.backgroundColor = .systemBackground
        self.view.tintColor = .darkGray
        self.navigationItem.backButtonTitle = ""
        
        setTabBarController()
        
        // trigger `viewDidLoad` for all child viewControllers
        for viewController in self.viewControllers ?? [] {
            if let navigationVC = viewController as? UINavigationController, let rootVC = navigationVC.viewControllers.first {
                let _ = rootVC.view
            } else {
                let _ = viewController.view
            }
        }
    }
    
    private func setTabBarController() {
        let controllers = [newsfeedNavController,
                           friendNavController,
                           profileNavController,
                           notificationNavController,
                           menuNavController]
        
        self.viewControllers = controllers
        self.tabBar.backgroundColor = .systemBackground
    }
    
    lazy var newsfeedNavController: UINavigationController = {
        let newsfeedTabViewController = UINavigationController(rootViewController: NewsfeedTabViewController())
        let newsfeedTabViewIcon = UITabBarItem(title: "뉴스피드", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        newsfeedTabViewController.tabBarItem = newsfeedTabViewIcon
        return newsfeedTabViewController
    }()
    
    lazy var friendNavController: UINavigationController = {
        let friendTabViewController = UINavigationController(rootViewController: FriendTabViewController())
        let friendTabViewIcon = UITabBarItem(title: "친구", image: UIImage(systemName: "person.2"), selectedImage: UIImage(systemName: "person.2.fill"))
        friendTabViewController.tabBarItem = friendTabViewIcon
        return friendTabViewController
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
    
    lazy var menuNavController: UINavigationController = {
        let menuTabViewController = UINavigationController(rootViewController: MenuTabViewController())
        let menuTabViewIcon = UITabBarItem(title: "메뉴", image: UIImage(systemName: "line.3.horizontal"), selectedImage: UIImage(systemName: "line.3.horizontal", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)))
        menuTabViewController.tabBarItem = menuTabViewIcon
        return menuTabViewController
    }()
}
