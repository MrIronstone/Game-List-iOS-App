//
//  HomePresenter.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 8.07.2022.
//

import Foundation

class HomePresenter: ViewToPresenterHomeProtocol {

    var homeInteractorObject: PresenterToInteractorHomeProtocol?
    
    var homeViewObject: PresenterToViewHomeProtocol?
    
    var homeDetailViewObject: PresenterToDetailViewHomeProtocol?
    
    var homeWishlistViewObject: PresenterToWishlistViewHomeProtocol?
    
    func viewGames(requestedPage page: Int) {
        homeInteractorObject?.getAllGames(requestedPage: page)
        
    }
    
    func viewGamesBySearchText(searchText text: String) {
        homeInteractorObject?.getGamesBySearch(searchText: text)
    }
    
    func viewGamesBySearchTextAndFilter(searchText text: String, filter: String) {
        homeInteractorObject?.getGamesBySearchAndFilter(searchText: text, filter: filter)
    }
    
    func viewGameDetails(requestedGameId id: Int) {
        homeInteractorObject?.getSingleGameDetails(requestedGameId: id)
    }
    
    func viewWishlistedGames() {
        homeInteractorObject?.getWishlist()
    }
    
    func loadNextPage(urlOfNextPage:String) {
        homeInteractorObject?.getNextPage(url: urlOfNextPage)
    }
    
    func isThisGameWishlisted(gameId: Int) -> Bool {
        if ( homeInteractorObject!.checkGamesWishlistState(requestedId: gameId)) {
            return true
        } else {
            return false
        }
    }
    
    func addGameToWishlist(requestedGameId:Int){
        homeInteractorObject?.addToWishlist(requestedGameId: requestedGameId)
    }
    
    func removeGameFromWishlist(requestedGameId:Int){
        homeInteractorObject?.removeFromWishlist(requestedId: requestedGameId)
    }
    
    func viewAllPlatforms() {
        homeInteractorObject?.getAllPlatforms()
    }
}

extension HomePresenter: InteractorToPresenterHomeProtocol {
    func sendAllGamesDataToPresenter(gameList: RawgGamesResponse) {
        homeViewObject?.sendAllGamesDataToView(gameList: gameList)
    }
    
    func sendSingleGameDetailsToPresenter(gameDetails: RawgGameResponse) {
        homeDetailViewObject?.sendGameDetails(gameDetails: gameDetails)
    }
    
    func sendEmptyResults() {
        let emptyList = RawgGamesResponse(count: 0, previous: "", results: [], next: "")
        homeViewObject?.sendAllGamesDataToView(gameList: emptyList)
    }
    
    func sendAllWishlistedGamesToPresenter(gameList: [RawgGameResponse]) {
        homeWishlistViewObject?.sendAllGamesDataToView(gameList: gameList)
    }
    
    func sendAllPlatformsToThePresenter(platformList listOfPlatforms:RawgPlatformsResponse) {
        homeViewObject?.sendAllPlatforms(platformList: listOfPlatforms )
    }
}
