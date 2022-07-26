//
//  HomeProtocols.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 1.07.2022.
//

import Foundation

protocol ViewToPresenterHomeProtocol {
    var homeInteractorObject: PresenterToInteractorHomeProtocol? { get set}
    var homeViewObject: PresenterToViewHomeProtocol? { get set}
    var homeDetailViewObject: PresenterToDetailViewHomeProtocol? { get set}
    var homeWishlistViewObject: PresenterToWishlistViewHomeProtocol? { get set}

    func viewGames(requestedPage:Int)
    
    func viewGamesBySearchText(searchText text: String)
    
    func viewGamesBySearchTextAndFilter(searchText text: String, filter: String)
    
    func viewGameDetails(requestedGameId:Int)
    
    func loadNextPage(urlOfNextPage:String)
    
    func addGameToWishlist(requestedGameId:Int)
    func removeGameFromWishlist(requestedGameId:Int)
    func isThisGameWishlisted(gameId: Int) -> Bool
    func viewWishlistedGames()
    
    func viewAllPlatforms()
}


protocol PresenterToInteractorHomeProtocol {
    var homePresenterObject: InteractorToPresenterHomeProtocol? { get set}
    
    func getAllGames(requestedPage:Int)
    func getSingleGameDetails(requestedGameId:Int)
    func getNextPage(url:String)
    func getGamesBySearch(searchText: String)
    func getGamesBySearchAndFilter(searchText: String, filter: String)
    func addToWishlist(requestedGameId: Int)
    func removeFromWishlist(requestedId: Int)
    func checkGamesWishlistState(requestedId:Int) -> Bool
    func getWishlist()
    func getAllPlatforms()
}

protocol InteractorToPresenterHomeProtocol {
    func sendAllGamesDataToPresenter(gameList:RawgGamesResponse) // TODO entity gelecek
    func sendSingleGameDetailsToPresenter(gameDetails:RawgGameResponse)
    func sendEmptyResults()
    func sendAllWishlistedGamesToPresenter(gameList: [RawgGameResponse])
    func sendAllPlatformsToThePresenter(platformList: RawgPlatformsResponse)
}

protocol PresenterToViewHomeProtocol {
    func sendAllGamesDataToView(gameList:RawgGamesResponse) // TODO entity gelecek
    func sendAllPlatforms(platformList: RawgPlatformsResponse)

}

protocol PresenterToDetailViewHomeProtocol {
    func sendGameDetails(gameDetails:RawgGameResponse)
}

// presenter'dan wishlist ekranına yol
protocol PresenterToWishlistViewHomeProtocol {
    func sendAllGamesDataToView(gameList:[RawgGameResponse])
}

protocol PresenterToRouterHomeProtocol {
    static func execModule(ref:HomeViewController)
    static func execDetailModule(ref:DetailViewController)
    static func execWishlistModule(ref:HomeWishlistViewController)
}
