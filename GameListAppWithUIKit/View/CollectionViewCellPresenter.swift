//
//  CollectionViewCellPresenter.swift
//  GameListAppWithUIKit
//
//  Created by admin on 5.02.2024.
//


import Foundation

protocol CollectionViewCellPresenterInterface: AnyObject {
    func load()
}

final class CollectionViewCellPresenter {
    private weak var view: CollectionViewCellInterface?
    private let game: RawgGameResponse

    var viewedCell: [Int] = []
    

    init(view: CollectionViewCellInterface, game: RawgGameResponse) {
        self.view = view
        self.game = game
    }
    private func configureCell() {
        view?.setGameTitle(game.name ?? "")
        setBackgroundImage()
        view?.prepareUI()
    }
    
    func subToNotificiations(){
        NotificationCenter.shared.addObservers(observer: view as! Observer)
    }
    
    func setLabelGray() {
        if !ViewedGames.shared.viewedGames.contains(game.id) {
            ViewedGames.shared.viewedGames.append(game.id)
        }
        view?.changeTitleColorToViewed()
    }
    
    func setBackgroundImage() {
        guard let background_image = game.background_image else { return }
        
        let components = background_image.components(separatedBy: "media/games/")

        if components.count == 2 {
            let modifiedURL = components[0] + "media/crop/600/400/games/" + components[1]
            let url = URL(string: modifiedURL)
            view?.setBackgroundImage(url)
        } else {
            let url = URL(string: background_image)
            view?.setBackgroundImage(url)
        }
    }
    
    func checkIfItIsViewed() {
        if ViewedGames.shared.viewedGames.contains(self.game.id) {
            print("\(String(describing: game.id)) has been already viewed")
            view?.changeTitleColorToViewed()
        }
    }
    
    
    func setButtonValue(gameId: Int) {
        view?.assignButtonTag(gameId: gameId)
    }
}

extension CollectionViewCellPresenter: CollectionViewCellPresenterInterface {
    func load() {
        configureCell()
    }
}

extension CollectionViewCellPresenter: Observer {
    // observer func
    func unWishlisted(gameId id: Int) {
        if self.game.id == id {
            view?.changeFavButtonColorToGray()
        }
    }
    
    func wishlist(gameId id: Int) {
        if self.game.id == id {
            view?.changeFavButtonColorToGreen()
        }
    }
    
    // observer func
    func visitedGame(gameId id: Int) {
        if self.game.id == id {
            setLabelGray()
        }
    }
}
