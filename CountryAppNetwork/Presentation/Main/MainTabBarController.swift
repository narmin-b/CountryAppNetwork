//
//  MainTabBarController.swift
//  CountryAppNetwork
//
//  Created by Narmin Baghirova on 07.12.24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        configureView()
    }
    
    fileprivate func configureView() {
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
    }
    
    fileprivate func setUpTabBar() {
        let mainItem = MainViewController(viewModel: MainViewModel())
        let mainIcon = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        mainItem.tabBarItem = mainIcon
    
        let controllers = [mainItem]
        self.viewControllers = controllers
    }
}
