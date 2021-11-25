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
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let newsfeedTabViewController = UINavigationController(rootViewController: NewsfeedTabViewController())
        let newsfeedTabViewIcon = UITabBarItem(title: "뉴스피드", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        newsfeedTabViewController.tabBarItem = newsfeedTabViewIcon
        
        let profileTabViewController = UINavigationController(rootViewController: ProfileTabViewController())
        let profileTabViewIcon = UITabBarItem(title: "프로필", image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        profileTabViewController.tabBarItem = profileTabViewIcon
        
        let notificationTabViewController = UINavigationController(rootViewController: NotificationTabViewController())
        let notificationTabViewIcon = UITabBarItem(title: "알림", image: UIImage(systemName: "bell"), selectedImage: UIImage(systemName: "bell.fill"))
        notificationTabViewController.tabBarItem = notificationTabViewIcon

        let controllers = [newsfeedTabViewController,
                           profileTabViewController,
                           notificationTabViewController]
        
        self.viewControllers = controllers
        self.tabBar.backgroundColor = UIColor.white
    }

}
