//
//  DetailInteractor.swift
//  GameListAppWithUIKit
//
//  Created by admin on 13.02.2024.
//

import Foundation

protocol DetailInteractorInterface: AnyObject {
    func getSingleGameDetails(requestedGameId: Int)    
    
    func addToWishlist(requestedGameId: Int)
    func removeFromWishlist(requestedId: Int)
    func checkGamesWishlistState(requestedId:Int) -> Bool
}

protocol DetailInteractorInterfaceOutput: AnyObject {
    func handleSingleGameDetails(result: GameResult)
}

final class DetailInteractor {
    weak var output: DetailInteractorInterfaceOutput?
}


extension DetailInteractor: DetailInteractorInterface {
    func getSingleGameDetails(requestedGameId: Int) {
        NetworkEngine.request(endpoint: RAWGEndpoint.getGame(gameId: requestedGameId)) { [weak self] (result: GameResult) in
            self?.output?.handleSingleGameDetails(result: result)
        }
    }
    
    func addToWishlist(requestedGameId: Int) {
        FavoriteManager.shared.addToFavorite(id: requestedGameId)
    }
    
    func removeFromWishlist(requestedId: Int) {
        FavoriteManager.shared.removeFromFavorite(id: requestedId)
    }
    
    
    func checkGamesWishlistState(requestedId:Int) -> Bool {
        FavoriteManager.shared.checkIsFavorite(id: requestedId)
    }
}
