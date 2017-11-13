//
//  TabbarController.swift
//  AnyProj
//
//  Created by Александр Иванин on 12.11.17.
//

import UIKit

class TabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        setupControllers()
    }
    
    private func setupControllers() {
        let searchTab = SearchViewController()
        let searchTabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "search"), tag: 0)
        searchTab.tabBarItem = searchTabBarItem
        
        
        let basketTab = BasketViewController()
        let basketTabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "basket"), tag: 1)
        basketTab.tabBarItem = basketTabBarItem
        
        let settingsTab = SettingsViewController()
        let settingsTabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "settings"), tag: 2)
        settingsTab.tabBarItem = settingsTabBarItem
        
        
        self.viewControllers = [searchTab, basketTab, settingsTab]
    }
}

extension TabbarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}
