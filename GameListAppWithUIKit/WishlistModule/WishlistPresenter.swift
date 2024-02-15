//
//  WishlistPresenter.swift
//  GameListAppWithUIKit
//
//  Created by admin on 7.02.2024.
//

import Foundation

private extension WishlistPresenter {
    enum Constant {
    }
}

protocol WishlistPresenterInterface: AnyObject {
    var numberOfItems: Int { get }

    func item(at index: Int) -> RawgGameResponse?
    func wishlistButtonTapped()
    
    func viewDidLoad()
}

final class WishlistPresenter {
    private weak var view: WishlistViewInterface?
    private let router: WishlistRouterInterface
    private let interactor: WishlistInteractorInterface
    
    var gameListResponse: [GameEntity]?
    var gameList = [RawgGameResponse]()

    init(view: WishlistViewInterface,
         interactor: WishlistInteractorInterface,
         router: WishlistRouterInterface) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    @objc private func fetchWishlistedGames() {
        // view?.showLoading()
        interactor.fetchWishlistedGames()
    }
}

extension WishlistPresenter: WishlistPresenterInterface {
    var numberOfItems: Int {
        gameList.count
    }
    
    func item(at index: Int) -> RawgGameResponse? {
        gameList[index]
    }
    
    func wishlistButtonTapped() {
        // TODO: 
    }
    
    func viewDidLoad() {
        view?.prepareUI()
        fetchWishlistedGames()
    }
}

extension WishlistPresenter: WishlistInteractorInterfaceOutput {
    func handleGameListResult(gameListResult: Result<[GameEntity], Error>) {
        switch gameListResult {
        case .success(let success):
            gameListResponse = success
            for gameEntitiy in success {
                gameList.append(RawgGameResponse(id: Int(gameEntitiy.id),
                                                 name: nil,
                                                 description_raw: nil,
                                                 released: nil,
                                                 metacritic: nil,
                                                 playtime: nil,
                                                 genres: nil,
                                                 parent_platforms: nil,
                                                 publishers: nil,
                                                 background_image: nil,
                                                 reddit_url: nil,
                                                 website: nil))
            }
            view?.loadGames()
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
}

