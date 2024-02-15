//
//  HomeRouter.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 8.07.2022.©
//

import UIKit


protocol HomeRouterInterface: AnyObject {
    func navigateToDetail(withGameId id: Int)
}

final class HomeRouter {
    weak var navigationController: UINavigationController?
    weak var presenter: HomePresenterInterface?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    static func createHomeModule(usingNavController navController: UINavigationController) -> HomeViewController {
        
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let interactor = HomeInteractor()
        let router = HomeRouter(navigationController: navController)
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)

        router.presenter = presenter
        view.presenter = presenter
        interactor.output = presenter

        return view
    }
}

extension HomeRouter: HomeRouterInterface {
    func navigateToDetail(withGameId id: Int) {
        
        if let navController = navigationController {
            // let detailView = createDetailModule
            // navController.pushViewController(detailView, animated: true)
        }
    }
}
