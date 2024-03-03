//
//  TabBarController.swift
//  GameListAppWithUIKit
//
//  Created by admin on 12.02.2024.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureViewControllers() {
        // Create Tab one
        let navController1 = UINavigationController()
        let homeView = HomeRouter.createHomeModule(usingNavController: navController1)
        navController1.pushViewController(homeView, animated: false)
        let tabOneBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller"), selectedImage: UIImage(named: "gamecontroller.fill"))
        
        homeView.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let navController2 = UINavigationController()
        let wishlistView = WishlistRouter.createWishlistModule(usingNavController: navController2)
        navController2.pushViewController(wishlistView, animated: false)
        let tabTwoBarItem2 = UITabBarItem(title: "Wishlist", image: UIImage(systemName: "gift"), selectedImage: UIImage(named: "gift.fill"))
        
        wishlistView.tabBarItem = tabTwoBarItem2
        
        self.viewControllers = [navController1, navController2]
    }
}
