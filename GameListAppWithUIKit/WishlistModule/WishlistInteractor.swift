//
//  WishlistInteractor.swift
//  GameListAppWithUIKit
//
//  Created by admin on 8.02.2024.
//

import Foundation

protocol WishlistInteractorInterface {
    func fetchWishlistedGames()
}

protocol WishlistInteractorInterfaceOutput: AnyObject {
    func handleGameListResult(gameListResult: Result<[GameEntity], Error>)
}

final class WishlistInteractor {
    weak var output: WishlistInteractorInterfaceOutput?
}

// MARK: - AddressListInteractorInterface
extension WishlistInteractor: WishlistInteractorInterface {
    func fetchWishlistedGames() {
        FavoriteManager.shared.allGames { [weak self] result in
            self?.output?.handleGameListResult(gameListResult: result)
        }
    }
}

