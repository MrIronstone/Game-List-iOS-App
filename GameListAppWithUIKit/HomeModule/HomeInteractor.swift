//
//  HomeInteractor.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 8.07.2022.
//

import Foundation

protocol HomeInteractorInterface {
    func fetchPlatforms()
    func appendToWishlist(gameDetails: RawgGameResponse)
    func getAllGames(requestedPage:Int)
    func getSingleGameDetails(requestedGameId: Int)
    func getGamesBySearch(searchText: String)
    func getGamesBySearchAndFilter(searchText: String, filter: String)
    func getNextPage(url:String)
    
    func addToWishlist(requestedGameId: Int)
    func removeFromWishlist(requestedId: Int)
    func checkGamesWishlistState(requestedId:Int) -> Bool
}

typealias GamesResult = Result<RawgGamesResponse, Error>
typealias GameResult = Result<RawgGameResponse, Error>
typealias PlatformsResult = Result<RawgPlatformsResponse, Error>

protocol HomeInteractorInterfaceOutput: AnyObject {
    func handleGameSearchResult(result: GamesResult)
    func handlePlatformsResult(result: PlatformsResult)
    func handleNextPageResult(result: GamesResult)
    func handleSingleGameDetails(result: GameResult)
}

final class HomeInteractor {
    weak var output: HomeInteractorInterfaceOutput?
}

// MARK: - HomeInteractorInterface
extension HomeInteractor: HomeInteractorInterface {
    func fetchPlatforms() {
        NetworkEngine.request(endpoint: RAWGEndpoint.getAllPlatforms) { [weak self] (result: PlatformsResult) in
            self?.output?.handlePlatformsResult(result: result)
        }

    }
    
    func appendToWishlist(gameDetails: RawgGameResponse) {
        FavoriteManager.shared.addToFavorite(id: gameDetails.id)
    }
    
    func getAllGames(requestedPage: Int) {
        NetworkEngine.request(endpoint: RAWGEndpoint.getAllGames(page: requestedPage)) { [weak self] (result: GamesResult) in
            self?.output?.handleGameSearchResult(result: result)
        }
    }
    
    func getSingleGameDetails(requestedGameId: Int) {
        NetworkEngine.request(endpoint: RAWGEndpoint.getGame(gameId: requestedGameId)) { [weak self] (result: GameResult) in
            self?.output?.handleSingleGameDetails(result: result)
        }
    }
    
    func getGamesBySearch(searchText: String) {
        NetworkEngine.request(endpoint: RAWGEndpoint.getSearchResult(searchedText: searchText)) { [weak self] (result: GamesResult) in
            self?.output?.handleGameSearchResult(result: result)
        }
    }

    
    func getGamesBySearchAndFilter(searchText: String, filter: String) {
        NetworkEngine.request(endpoint: RAWGEndpoint.getResultsOfTextAndFilter(searchedText: searchText, selectedParentFilter: filter)) { [weak self] (result: GamesResult) in
            self?.output?.handleGameSearchResult(result: result)
        }
    }
    
    func getNextPage(url: String) {
        NetworkEngine.requestByUrl(url: url)  { [weak self] (result: GamesResult) in
            self?.output?.handleNextPageResult(result: result)
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
