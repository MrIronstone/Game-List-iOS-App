//
//  DetailRouter.swift
//  GameListAppWithUIKit
//
//  Created by admin on 13.02.2024.
//

import Foundation
import UIKit

protocol DetailRouterInterface: AnyObject {
    
}

public struct DetailModuleArguments {
    public let gameId: Int
    public let gameTitle: String
    public let posterImage: String
    public let backdropImage: String
    
    init(gameId: Int,
         gameTitle: String,
         posterImage: String,
         backdropImage: String) {
        self.gameId = gameId
        self.gameTitle = gameTitle
        self.posterImage = posterImage
        self.backdropImage = backdropImage
    }
}

final class DetailRouter {
    weak var navigationController: UINavigationController?
    weak var presenter: DetailPresenterInterface?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    static func createHomeModule(usingNavController navController: UINavigationController,
                                 arguments: DetailModuleArguments) -> DetailViewController {
        
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let interactor = DetailInteractor()
        let router = DetailRouter(navigationController: navController)
        let presenter = DetailPresenter(view: view, interactor: interactor, router: router, arguments: arguments)

        router.presenter = presenter
        view.presenter = presenter
        interactor.output = presenter

        return view
    }
}

extension DetailRouter: DetailRouterInterface {
    
}
