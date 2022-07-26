//
//  HomeInteractor.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 8.07.2022.
//

import Foundation

class HomeInteractor: PresenterToInteractorHomeProtocol {
    var homePresenterObject: InteractorToPresenterHomeProtocol?
    
    var wishList: [RawgGameResponse] = []
    
    func getGamesBySearch(searchText: String) {
        NetworkEngine.request(endpoint: RAWGEndpoint.getSearchResult(searchedText: searchText)) { (result: Result<RawgGamesResponse, Error>) in
            switch result {
            case .success(let success):
                print("Succeed to retrieve game list with search text of \(searchText) ")
                self.homePresenterObject?.sendAllGamesDataToPresenter(gameList: success)
            case .failure(let failure):
                print("Failed while trying to retrieve game list with search text of \(searchText) : ", failure.localizedDescription)
                self.homePresenterObject?.sendEmptyResults()

            }
        }
    }
    
    func getGamesBySearchAndFilter(searchText: String, filter: String) {
        NetworkEngine.request(endpoint: RAWGEndpoint.getResultsOfTextAndFilter(searchedText: searchText, selectedParentFilter: filter)) { (result: Result<RawgGamesResponse, Error>) in
            switch result {
            case .success(let success):
                print("Succeed to retrieve game list with search text of \(searchText) ")
                self.homePresenterObject?.sendAllGamesDataToPresenter(gameList: success)
            case .failure(let failure):
                print("Failed while trying to retrieve game list with search text of \(searchText) : ", failure.localizedDescription)
                self.homePresenterObject?.sendEmptyResults()

            }
        }
    }
    
    
    func getSingleGameDetails(requestedGameId: Int) {
        NetworkEngine.request(endpoint: RAWGEndpoint.getGame(gameId: requestedGameId)) { (result: Result<RawgGameResponse, Error>) in
            switch result {
            case .success(let success):
                print("Succeed to retrieve infos of \(success.name!)")
                self.homePresenterObject?.sendSingleGameDetailsToPresenter(gameDetails: success)
            case .failure(let failure):
                print("Failed to retrieve game infos : ", failure.localizedDescription)

            }
        }
    }
    
    func getAllGames(requestedPage:Int) {
        // servis ile iletişimi burası kuracak
        
        NetworkEngine.request(endpoint: RAWGEndpoint.getAllGames(page: requestedPage)) { (result: Result<RawgGamesResponse, Error>) in
            switch result {
            case .success(let success):
                print("Succeed to retrieve game list at page \(requestedPage). Game Count: \(success.results!.count)")
                self.homePresenterObject?.sendAllGamesDataToPresenter(gameList: success)
            case .failure(let failure):
                print("Failed while trying to retrieve game list at page \(requestedPage) : ", failure.localizedDescription)
            }
        }
    }
    
    func getNextPage(url:String) {
        NetworkEngine.requestByUrl(url: url)  { (result: Result<RawgGamesResponse, Error>) in
            switch result {
            case .success(let success):
                print("Succeed to retrieve game list next page")
                self.homePresenterObject?.sendAllGamesDataToPresenter(gameList: success)
            case .failure(let failure):
                print("Failed while trying to retrieve game list on the next page : ", failure.localizedDescription)
            }
        }
    }
    
    func addToWishlist(requestedGameId: Int) {
        var extractedWishlist = UserDefaults.standard.object(forKey: "wishlistedGamesIDs") as? [Int] ?? [Int]()
        extractedWishlist.append(requestedGameId)
        UserDefaults.standard.set(extractedWishlist,forKey: "wishlistedGamesIDs")
        

    }
    
    func removeFromWishlist(requestedId: Int) {
        var extractedWishlist = UserDefaults.standard.object(forKey: "wishlistedGamesIDs") as? [Int] ?? [Int]()
        if (extractedWishlist.contains(where: {$0 == requestedId })) {
            extractedWishlist.removeAll(where: {$0 == requestedId })
            print(extractedWishlist)
            UserDefaults.standard.set(extractedWishlist,forKey: "wishlistedGamesIDs")
            
        }
    }
    
    
    func checkGamesWishlistState(requestedId:Int) -> Bool {
        let extractedWishlist = UserDefaults.standard.object(forKey: "wishlistedGamesIDs") as? [Int] ?? [Int]()
        if (extractedWishlist.contains(where: {$0 == requestedId })) {
            return true
        } else {
            return false
        }
    }
    
    func getWishlist() {
        let extractedWishlist = UserDefaults.standard.object(forKey: "wishlistedGamesIDs") as? [Int] ?? [Int]()
        
        wishList = []
        
        // hali hazırda tüm wishisttekileri silince bu if'e girecek
        if(extractedWishlist.count == 0) {
            homePresenterObject?.sendAllWishlistedGamesToPresenter(gameList: [])
        }
        
        for gameId in extractedWishlist {
            NetworkEngine.request(endpoint: RAWGEndpoint.getGame(gameId: gameId)) { (result: Result<RawgGameResponse, Error>) in
                switch result {
                case .success(let success):
                    print("Succeed to retrieve infos of \(success.name!)")
                    self.appendToWishlist(gameDetails: success)
                case .failure(let failure):
                    print("Failed to retrieve game infos : ", failure.localizedDescription)

                }
            }
        }
    }
    
    private func appendToWishlist(gameDetails: RawgGameResponse) {
        let extractedWishlist = UserDefaults.standard.object(forKey: "wishlistedGamesIDs") as? [Int] ?? [Int]()
        
        wishList.append(gameDetails)
        
        if (wishList.count == extractedWishlist.count) {
            print("\(wishList.count) game details has been sent to presenter")
            homePresenterObject?.sendAllWishlistedGamesToPresenter(gameList: wishList)
        }
    }
    
    func getAllPlatforms() {
        NetworkEngine.request(endpoint: RAWGEndpoint.getAllPlatforms) { (result: Result<RawgPlatformsResponse, Error>) in
            switch result {
            case .success(let success):
                print("Succeed to retrieve infos about platforms. There has been \(success.count!) platform found")
                self.homePresenterObject?.sendAllPlatformsToThePresenter(platformList: success)
            case .failure(let failure):
                print("Failed to retrieve platforms : ", failure.localizedDescription)

            }
        }
    }
}
