//
//  CustomTabBarViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 16.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupNavigationBar()
    }
    
    func setupTabBar() {
        let scanViewNavigationController = UINavigationController(rootViewController: ScanViewController())
        if #available(iOS 13.0, *) {
            scanViewNavigationController.tabBarItem.image = UIImage(systemName: "viewfinder")
        } else {
            scanViewNavigationController.tabBarItem.title = "Scan"
        }
        
        let machineListViewNavigationController = MachineListViewController()
        if #available(iOS 13.0, *) {
            machineListViewNavigationController.tabBarItem.image = UIImage(systemName: "list.bullet")
        } else {
            machineListViewNavigationController.tabBarItem.title = "List"
        }
        
        let profileViewNavigationController = ProfileViewController()
        if #available(iOS 13.0, *) {
            profileViewNavigationController.tabBarItem.image = UIImage(systemName: "person")
        } else {
            profileViewNavigationController.tabBarItem.title = "Profile"
        }
        
        UITabBar.appearance().tintColor = .black
        viewControllers = [scanViewNavigationController, machineListViewNavigationController, profileViewNavigationController]
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(passToCreating))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func passToCreating() {
        let destination = CreatingViewController(nibName: "CreatingViewController", bundle: nil)
        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    
}
