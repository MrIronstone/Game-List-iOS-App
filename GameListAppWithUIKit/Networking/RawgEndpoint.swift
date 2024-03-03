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
        case .getAllGames, .getSearchResult, .getResultsOfTextAndFilter:
            return "/api/games"
        case .getGame(let gameId):
            return "/api/games/\(gameId)"
        case .getAllPlatforms:
            return "/api/platforms/lists/parents"
        }
    }
    
    var parameters: [URLQueryItem] {
        let apiKey = "ec51b655020540038116005d4738f48c"
        
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
                    URLQueryItem(name: "search", value: String(text)),
                    URLQueryItem(name: "parent_platform", value: parentFilter)]
        }
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
}
