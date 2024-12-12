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
        tabBar.backgroundColor = .lightGray
        tabBar.tintColor = .black
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        tabBar.standardAppearance = appearance;
    }
    
    fileprivate func setUpTabBar() {
        let mainItem = MainViewController(viewModel: MainViewModel())
        let mainIcon = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let mainNavContr = UINavigationController(rootViewController: mainItem)
        mainItem.tabBarItem = mainIcon
        mainItem.navigationItem.title = "Country List"
        mainItem.navigationController?.navigationBar.shadowImage = UIImage()
    
        let controllers = [mainNavContr]
        self.viewControllers = controllers
    }
}
