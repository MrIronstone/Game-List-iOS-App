//
//  DetailPresenter.swift
//  GameListAppWithUIKit
//
//  Created by admin on 13.02.2024.
//

import Foundation
import UIKit

extension DetailPresenter {
    private enum Colors {
        enum WishlistButtonColors {
            static let greenColor = UIColor(red: 93.0/255.0, green: 197.0/255.0, blue: 52.0/255.0, alpha: 1.0)
            static let grayColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        }
    }
}

protocol DetailPresenterInterface: AnyObject {
    func wishlistButtonTapped()
    func descriptionTextTapped(numberOfLines: Int)
    func redditButtonTapped()
    func websiteButtonTapped()
    
    func viewDidLoad()
}

final class DetailPresenter {
    private weak var view: DetailViewInterface?
    private let router: DetailRouterInterface
    private let interactor: DetailInteractorInterface
    
    var gameId: Int = 0

    var gameDetails = RawgGameResponse(id: 0, name: "", description_raw: "", released: "", metacritic: 0.0, playtime: 0, genres: [], parent_platforms: [], publishers: [], background_image: "", reddit_url: "", website: "")

    init(view: DetailViewInterface,
         interactor: DetailInteractorInterface,
         router: DetailRouterInterface) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // açılan oyunun wishlistte olup olmadığını kontrol edip ona göre navBar'daki tuşu boyuyor
    // bunu bu view ilk açıldığında kullanıyorum sadece
    func checkIfTheGameIsWishlisted() {
        if interactor.checkGamesWishlistState(requestedId: gameId) {
            view?.changeNavBarButtonColor(color: Colors.WishlistButtonColors.greenColor)
        } else {
            view?.changeNavBarButtonColor(color: .white)
        }
    }
    
    func preparePhoto() {
        if let photoUrl = gameDetails.background_image {
            if let url = URL(string: photoUrl) {
                view?.setBackgroundPhoto(photoUrl: url)
            }
        }
    }
    
    func prepareReleaseDate() {
        guard let releaseDate = gameDetails.released else { return }
        view?.changeReleaseDateText(text: releaseDate)
    }
    
    func prepareGenres() {
        guard let gameGenres = gameDetails.genres else { return }
        if gameGenres.count != 0 {
            var genres: [String] = []
            for genre in gameGenres {
                genres.append(genre.name!)
            }
            
            view?.changeGenreSectionText(text: genres.joined(separator: ", "))
        } else {
            view?.setGenreSectionVisibility(isHidden: true)
        }
    }
    
    func setPublishersSection () {
        guard let publishers = gameDetails.publishers else { return }
        if publishers.count != 0 {
            var tempPublishers: [String] = []
            for publisher in publishers {
                if let name = publisher.name {
                    tempPublishers.append(name)
                }
            }
            view?.changePublishersSectionText(text: tempPublishers.joined(separator: ", "))
        } else {
            view?.setPublishersSectionVisibility(isHidden: true)
        }
    }

    
    func preparePlaytime() {
        if self.gameDetails.playtime == 0 {
            view?.setPlaytimeSectionVisibility(isHidden: true)
        } else {
            let text = "\(self.gameDetails.playtime) hours"
            view?.changePlaytimeSectionText(text: text)
        }
    }
    
    func prepareDescription() {
        
    }
    
    func prepareMetacritic() {
        metacriticRating.layer.borderWidth = 0.5
        metacriticRating.layer.cornerRadius = 4
        metacriticRating.text = String(Int(rating))
        
        if ( rating == 0) {
            metacriticRating.isHidden = true
            return
        }
        
        if( rating <= 50) {
            metacriticRating.textColor = UIColor.red
            metacriticRating.layer.borderColor = UIColor.red.cgColor
        }
        else if ( rating <= 75) {
            metacriticRating.textColor = UIColor.yellow
            metacriticRating.layer.borderColor = UIColor.yellow.cgColor
        }
        else {
            metacriticRating.textColor = UIColor.green
            metacriticRating.layer.borderColor = UIColor.green.cgColor
        }
    }
}

extension DetailPresenter: DetailPresenterInterface {
    func descriptionTextTapped(numberOfLines: Int) {
        if (numberOfLines == 0) {
            view?.changeDescriptionTextLength(numberOfLines: 4)
        }
        else {
            view?.changeDescriptionTextLength(numberOfLines: 0)
        }
    }
    
    func redditButtonTapped() {
        if(!visitRedditView.isHidden) {
            UIApplication.shared.open(URL(string: gameDetails.reddit_url!)!)
            print("Clicked to Reddit Button")
        }
    }
    
    func websiteButtonTapped() {
        if(!visitWebsiteView.isHidden) {
            UIApplication.shared.open(URL(string: gameDetails.website!)!)
            print("Clicked to Website Button")
        }
    }
    
    func wishlistButtonTapped() {
        if(isThisGameWishlisted(gameId: self.gameId)){
            removeGameFromWishlist(requestedGameId: self.gameId)
            navBarWishlistButton.tintColor = .white
            
            // bir önceki ekranda wishlit butonu rengi değiştirmek için delegate
            //wishlistButtonDelegate.didTapWishlistButton(gameId: self.gameId, isWishlisted: false)
            
            // tüm ekranlardaki hücrelerde wishlist tuşu rengi değiştirmek için
            NotificationCenter.shared.notifyObserversAboutUnWishlist(gameId: self.gameId)
            
            // wishlist ekranında liste değişimi için bilgi
            NotificationCenter.shared.notifyWishlistScreenAboutChanges()
            
        } else {
            addGameToWishlist(requestedGameId: self.gameId)
            navBarWishlistButton.tintColor = Colors.WishlistButtonColors.greenColor
            
            // bir önceki ekranda wishlist tuşu ekranı değiştmek için delegate
            //wishlistButtonDelegate.didTapWishlistButton(gameId: self.gameId, isWishlisted: true)
            
            // tüm ekranlardaki hücrelerde wishlist tuşu rengi değiştirmek için
            NotificationCenter.shared.notifyObserverAboutWishlist(gameId: self.gameId)
            
            // wishlist ekranında liste değişimi için bilgi
            NotificationCenter.shared.notifyWishlistScreenAboutChanges()
        }
    }
    
    func viewDidLoad() {
        view?.startAnimating()
        interactor.getSingleGameDetails(requestedGameId: self.gameId)
        
        checkIfTheGameIsWishlisted()
        
        NotificationCenter.shared.notifyObserversAboutViewedGame(gameId: self.gameId)
        
    }
}

extension DetailPresenter: DetailInteractorInterfaceOutput {
    func handleSingleGameDetails(result: GameResult) {
        switch result {
        case .success(let response):
            self.gameDetails = response
            // view?.reloadData tarzı bir şey
        case .failure(let error):
            print("Error while handling single game details on DetailPresenter")
        }
    }
}
