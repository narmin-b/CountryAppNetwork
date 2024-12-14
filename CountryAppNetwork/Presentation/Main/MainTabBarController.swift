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
        tabBar.barTintColor = .black
        tabBar.backgroundColor = .backgroundColorMain.withAlphaComponent(0.5)
        tabBar.tintColor = .highlighted
        tabBar.unselectedItemTintColor = .main
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
        mainItem.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Futura", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.highlighted]
        mainItem.navigationController?.navigationBar.shadowImage = UIImage()
    
        let controllers = [mainNavContr]
        self.viewControllers = controllers
    }
}
