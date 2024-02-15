//
//  RawgApi.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 7.07.2022.
//

import Foundation

class RawgApi {
    func getAllGamesAtPage(requestedPage: Int)  {
                        
        NetworkEngine.request(endpoint: RAWGEndpoint.getAllGames(page: requestedPage)) { (result: Result<RawgGamesResponse, Error>) in
            switch result {
            case .success(let success):
                print("Succeeded: ",success)
            case .failure(let failure):
                print("Failed: ", failure)
            }
        }

    }
}
