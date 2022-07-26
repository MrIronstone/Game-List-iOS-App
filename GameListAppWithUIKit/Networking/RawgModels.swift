//
//  ApiService.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 30.06.2022.
//

import Foundation

struct RawgGamesResponse: Codable {
    let count: Int?
    let previous: String?
    let results: [RawgGameResponse]?
    let next: String?
}

struct RawgPlatformsResponse: Codable {
    let count: Int?
    let previous: String?
    let results: [Platform]?
    let next: String?
}

struct RawgGameResponse: Codable {
    let id: Int
    let name:String?
    let description_raw:String?
    let released: String
    let metacritic:Double?
    let playtime: Int?
    let genres: [Genre]?
    let parent_platforms: [Platform]?
    let publishers: [Publisher]?
    let background_image:String?
    let reddit_url:String?
    let website:String?
}

struct Publisher: Codable {
    let id: Int?
    let name: String?
}

struct Platform: Codable {
    let id: Int?
    let name: String?
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}
