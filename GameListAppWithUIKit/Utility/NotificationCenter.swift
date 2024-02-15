//
//  NotificationCenter.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 23.07.2022.
//

import Foundation

protocol Observer {
    func wishlist(gameId: Int)
    func unWishlisted(gameId:Int)
    func visitedGame(gameId:Int)
}

protocol WishlistView {
    func fetchChanges()
}

class NotificationCenter {
    
    static let shared: NotificationCenter = NotificationCenter()
    
    var observers: [Observer] = []
    
    var wishlistView: WishlistView?
    
    func addObservers(observer: Observer) {
        observers.append(observer)
    }
        
    func removeObserver(observer: Observer) {
        //
        
    }
    
    
    func notifyObserversAboutUnWishlist(gameId id: Int) {
        for observer in observers {
            observer.unWishlisted(gameId: id)
        }
    }
    
    func notifyObserversAboutViewedGame(gameId id: Int) {
        for observer in observers {
            observer.visitedGame(gameId: id)
        }
    }
    
    func notifyObserverAboutWishlist(gameId id: Int) {
        for observer in observers {
            observer.wishlist(gameId: id)
        }
    }
    
    func notifyWishlistScreenAboutChanges() {
        if let wishlistView = wishlistView {
            wishlistView.fetchChanges()
        }
    }
}
