//
//  HomePresenter.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 8.07.2022.
//

import Foundation

protocol HomePresenterInterface: AnyObject {
    var numberOfGames: Int { get }
    var numberOfPlatforms: Int { get }

    func itemForGames(at index: Int) -> RawgGameResponse?
    func itemForPlatforms(at index: Int) -> Platform?
    func wishlistButtonTapped(with gameId: Int)
    func viewDidLoad()
    func searchBarSearchButtonClicked(text: String)
    func willDisplay(at index: Int)
}

final class HomePresenter {
    
    private weak var view: HomeViewInterface?
    private let router: HomeRouterInterface
    private let interactor: HomeInteractorInterface
    
    var selectedPlatformFilter: String = ""
    var isFilterSelected: Bool = false
    var searchedWords: String = ""
    var platformList = RawgPlatformsResponse(count: 0, previous: "", results: [], next: "")
    var gameList = RawgGamesResponse(count: 0, previous: "", results: [], next: "")
    var currentPage = 1
    var isPageRefreshing: Bool = false

    
    init(view: HomeViewInterface,
         interactor: HomeInteractorInterface,
         router: HomeRouterInterface) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    /*
    deinit {
        NotificationCenter.default.removeObserver(self, name: .updateAddressList, object: nil)
    }
    */

    func viewGames(requestedPage page: Int) {
        interactor.getAllGames(requestedPage: page)
    }
    
    func viewGamesBySearchText(searchText text: String) {
        interactor.getGamesBySearch(searchText: text)
    }
    
    func viewGamesBySearchTextAndFilter(searchText text: String, filter: String) {
        interactor.getGamesBySearchAndFilter(searchText: text, filter: filter)
    }
    
    func viewGameDetails(requestedGameId id: Int) {
        interactor.getSingleGameDetails(requestedGameId: id)
    }
    
    func loadNextPage(urlOfNextPage:String) {
        interactor.getNextPage(url: urlOfNextPage)
    }
    
    func isThisGameWishlisted(gameId: Int) -> Bool {
        if (interactor.checkGamesWishlistState(requestedId: gameId)) {
            return true
        } else {
            return false
        }
    }
    
    private func addGameToWishlist(requestedGameId:Int){
        interactor.addToWishlist(requestedGameId: requestedGameId)
    }
    
    private func removeGameFromWishlist(requestedGameId:Int){
        interactor.removeFromWishlist(requestedId: requestedGameId)
    }
    
    func viewAllPlatforms() {
        interactor.fetchPlatforms()
    }
}

extension HomePresenter: HomePresenterInterface {
    
    func willDisplay(at index: Int) {
        if let realGameList = gameList.results {
            if index > realGameList.count - 4 && !isPageRefreshing {
                isPageRefreshing = true
                // bu sayede crash yemeyi engelliyoruz
                guard let urlToNextPage = gameList.next else {
                    return
                }
                view?.startAnimating()
                loadNextPage(urlOfNextPage: urlToNextPage)
            }
        }
    }
    
    func searchBarSearchButtonClicked(text: String) {
        // ilk önce listeyi boşaltalım
        gameList = RawgGamesResponse(count: 0, previous: "", results: [], next: "")
        view?.startAnimating()
        interactor.getGamesBySearchAndFilter(searchText: text, filter: selectedPlatformFilter)
    }
    
    var numberOfGames: Int {
        guard let results = gameList.results else { return 0 }
        return results.count
    }
    
    var numberOfPlatforms: Int {
        guard let results = platformList.results else { return 0 }
        return results.count
    }
    
    func itemForGames(at index: Int) -> RawgGameResponse? {
        guard let results = gameList.results else { return nil }
        return results[index]
    }
    
    func itemForPlatforms(at index: Int) -> Platform? {
        guard let results = platformList.results else { return nil }
        return results[index]
    }
    
    func wishlistButtonTapped(with gameId: Int) {
        if (isThisGameWishlisted(gameId: gameId)) {
            removeGameFromWishlist(requestedGameId: gameId)
            
            /*
            sender.backgroundColor = Colors.wishlistButtonColor.grayColor
            
            NotificationCenter.shared.wishlistView?.fetchChanges()
            
            // wishlist ekranında liste değişimi için bilgi
            NotificationCenter.shared.notifyWishlistScreenAboutChanges()
             */
            
        } else {
            addGameToWishlist(requestedGameId: gameId)
            
            /*
            sender.backgroundColor = Colors.wishlistButtonColor.greenColor
            
            // wishlist ekranında liste değişimi için bilgi
            NotificationCenter.shared.notifyWishlistScreenAboutChanges()
            
            NotificationCenter.shared.wishlistView?.fetchChanges()
             */
        }
    }
    
    func viewDidLoad() {
        view?.setupUI()
        interactor.getAllGames(requestedPage: self.currentPage)
        interactor.fetchPlatforms()
    }
}

extension HomePresenter: HomeInteractorInterfaceOutput {
    func handleGameSearchResult(result: GamesResult) {
        switch result {
        case .success(let response):
            self.gameList = response
            view?.loadGames()
        case .failure(let failure):
            print(failure)
        }
        view?.stopAnimating()
    }
    
    func handlePlatformsResult(result: PlatformsResult) {
        switch result {
        case .success(let response):
            self.platformList = response
            view?.loadPlatforms()
        case .failure(let failure):
            print(failure)
        }
        view?.stopAnimating()
    }
    
    func handleNextPageResult(result: GamesResult) {
        view?.stopAnimating()
        
        var oldGames: [RawgGameResponse]?
        var newGames: [RawgGameResponse]?
        
        oldGames = self.gameList.results
        newGames = gameList.results
        
        oldGames?.append(contentsOf: newGames!)
        
        let newList = RawgGamesResponse (count: gameList.count,
                                         previous: gameList.previous,
                                         results: oldGames,
                                         next: gameList.next)
        
        self.gameList = newList
        
        self.isPageRefreshing = false
        
        view?.loadGames()
        view?.stopAnimating()
        
        /*
        // yeni sayfa yükleme harici scroll bar'ı en tepeye alıyor müthiş güzel
        if(self.isPageRefreshing == false) {
            self.collectionView.setContentOffset(.zero, animated: true)
        }
        */
    }
    
    func handleSingleGameDetails(result: GameResult) {
        
        view?.stopAnimating()
    }
}
