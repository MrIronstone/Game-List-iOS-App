//
//  Singleton Patterns.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 23.07.2022.
//

import Foundation

class ViewedGames {
    var viewedGames:[Int] = []
    static let shared: ViewedGames = ViewedGames()
    
}
