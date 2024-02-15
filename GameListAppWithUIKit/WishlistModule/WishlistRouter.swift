//
//  WishlistRouter.swift
//  GameListAppWithUIKit
//
//  Created by admin on 8.02.2024.
//

import Foundation
import UIKit

protocol WishlistRouterInterface {
    func navigateToDetail(gameId: Int)
}

final class WishlistRouter {
    weak var navigationController: UINavigationController?
    weak var presenter: WishlistPresenterInterface?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    static func createWishlistModule(usingNavController navController: UINavigationController) -> WishlistViewController {
        
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WishlistViewController") as! WishlistViewController
        let interactor = WishlistInteractor()
        let router = WishlistRouter(navigationController: navController)
        let presenter = WishlistPresenter(view: view, interactor: interactor, router: router)

        router.presenter = presenter
        view.presenter = presenter
        interactor.output = presenter

        return view
    }
}

extension WishlistRouter: WishlistRouterInterface {
    func navigateToDetail(gameId: Int) {
        if let navController = navigationController {
            // let detailView =
        }
    }
    
    // navController.pushViewController(addressView, animated: true)
    
}
