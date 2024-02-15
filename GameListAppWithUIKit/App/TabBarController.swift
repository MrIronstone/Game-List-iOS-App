//
//  TabBarController.swift
//  GameListAppWithUIKit
//
//  Created by admin on 12.02.2024.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
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
        
        // Create Tab one
        let navController1 = UINavigationController()
        let homeView = HomeRouter.createHomeModule(usingNavController: navController1)
        let tabOneBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller"), selectedImage: UIImage(named: "gamecontroller.fill"))
        
        homeView.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let navController2 = UINavigationController()
        let wishlistView = WishlistRouter.createWishlistModule(usingNavController: navController2)
        let tabTwoBarItem2 = UITabBarItem(title: "Wishlist", image: UIImage(systemName: "gift"), selectedImage: UIImage(named: "gift.fill"))
        
        wishlistView.tabBarItem = tabTwoBarItem2
        
        
        self.viewControllers = [homeView, wishlistView]
    }
}
