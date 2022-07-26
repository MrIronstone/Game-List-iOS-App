//
//  rawgEndpoint.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 30.06.2022.
//

import Foundation

enum RAWGEndpoint: Endpoint {
    case getAllGames(page:Int)
    case getGame(gameId:Int)
    case getSearchResult(searchedText:String)
    case getAllPlatforms
    case getResultsOfTextAndFilter(searchedText:String, selectedParentFilter:String)
    // case getGenreFilteredResults(selectedGenre:String)
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return "api.rawg.io"
        }
    }
    
    var path: String {
        switch self {
        case .getAllGames:
            return "/api/games"
        case .getGame(let gameId):
            return "/api/games/\(gameId)"
        case .getSearchResult:
            return "/api/games"
        case .getAllPlatforms:
            return "/api/platforms/lists/parents"
        case .getResultsOfTextAndFilter:
            return "/api/games"
        }
    }
    
    var parameters: [URLQueryItem] {
        let apiKey = "cb7958d1969d436cacf6f87b2f0b6660"
        
        switch self {
            // tüm oyunlar ve sayfa için
        case .getAllGames(let page):
            return [URLQueryItem(name: "key", value: apiKey),
                    //URLQueryItem(name: "page_size", value: String(6)), // bu sayfaya gelen oyunları kısaltmama yarıyor
                    URLQueryItem(name: "page", value: String(page))]
            // spesifik olarak bir oyun için
        case .getGame:
            return [URLQueryItem(name: "key", value: apiKey)]
        case .getSearchResult(let text):
            return [URLQueryItem(name: "key", value: apiKey),
                    URLQueryItem(name: "search", value: text)]
        case .getAllPlatforms:
            return [URLQueryItem(name: "key", value: apiKey)]
        case .getResultsOfTextAndFilter(let text, let parentFilter):
            return [URLQueryItem(name: "key", value: apiKey),
                    URLQueryItem(name: "parent_platforms", value: parentFilter),
                    URLQueryItem(name: "search", value: String(text))]
        }
    }
    
    var method: String {
        switch self {
        case .getAllGames:
            return "GET"
        case .getGame:
            return "GET"
        case .getSearchResult:
            return "GET"
        case .getAllPlatforms:
            return "GET"
        case .getResultsOfTextAndFilter:
            return "GET"
        }
    }
}
