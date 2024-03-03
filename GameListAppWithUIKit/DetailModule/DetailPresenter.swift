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
    func checkButtons()
    
    func viewDidLoad()
}

final class DetailPresenter {
    private weak var view: DetailViewInterface?
    private let router: DetailRouterInterface
    private let interactor: DetailInteractorInterface
    private let arguments: DetailModuleArguments
    
    var gameId: Int = 0

    var gameDetails = RawgGameResponse(id: 0, name: "", description_raw: "", released: "", metacritic: 0.0, playtime: 0, genres: [], parent_platforms: [], publishers: [], background_image: "", reddit_url: "", website: "")

    init(view: DetailViewInterface,
         interactor: DetailInteractorInterface,
         router: DetailRouterInterface,
         arguments: DetailModuleArguments) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.arguments = arguments
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
                view?.setBackgroundPhotoVisibility(isHidden: false)
            }
        }
    }
    
    func prepareReleaseDate() {
        guard let releaseDate = gameDetails.released else { return }
        view?.changeReleaseDateText(text: releaseDate)
        view?.setReleaseDateTextVisibility(isHidden: false)
    }
    
    func prepareGenres() {
        guard let gameGenres = gameDetails.genres else { return }
        if gameGenres.count != 0 {
            var genres: [String] = []
            for genre in gameGenres {
                genres.append(genre.name!)
            }
            
            view?.changeGenreSectionText(text: genres.joined(separator: ", "))
            view?.setGenreSectionVisibility(isHidden: false)
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
            view?.setPublishersSectionVisibility(isHidden: false)
        } else {
            view?.setPublishersSectionVisibility(isHidden: true)
        }
    }
    
    func preparePlaytime() {
        if self.gameDetails.playtime == 0 {
            view?.setPlaytimeSectionVisibility(isHidden: true)
        } else {
            guard let playtime = gameDetails.playtime else { return }
            let text = "\(playtime) hours"
            view?.changePlaytimeSectionText(text: text)
            view?.setPlaytimeSectionVisibility(isHidden: false)
        }
    }
    
    func prepareDescription() {
        if let description = gameDetails.description_raw {
            view?.changeDescriptionText(text: description)
            view?.setDescriptionTextLength(numberOfLines: 4)
            view?.setDescriptionTextVisibility(isHidden: false)
        } else {
            view?.setDescriptionTextVisibility(isHidden: true)
        }
    }
    
    func prepareMetacritic() {
        guard let metacritic = gameDetails.metacritic else { return }
        
        if (metacritic == 0) {
            view?.setMetacriticSectionVisibility(isHidden: true)
            return
        }
        if(metacritic <= 50) {
            view?.setMetacriticSection(text: String(Int(metacritic)), color: UIColor.red)
            view?.setMetacriticSectionVisibility(isHidden: false)
            return
        }
        else if (metacritic <= 75) {
            view?.setMetacriticSection(text: String(Int(metacritic)), color: UIColor.yellow)
            view?.setMetacriticSectionVisibility(isHidden: false)
            return
        }
        else {
            view?.setMetacriticSection(text: String(Int(metacritic)), color: UIColor.green)
            view?.setMetacriticSectionVisibility(isHidden: false)
            return
        }
    }
    
    func prepareGameTitle() {
        if let gameName = gameDetails.name {
            view?.setGameTitleVisibility(isHidden: false)
            view?.changeGameTitle(text: gameName)
        } else {
            view?.setGameTitleVisibility(isHidden: true)
        }
    }
    
    func setupUI() {
        preparePhoto()
        prepareReleaseDate()
        prepareGenres()
        setPublishersSection()
        preparePlaytime()
        prepareDescription()
        prepareGameTitle()
        prepareMetacritic()
        view?.setStackViewVisibility(isHidden: false)
    }
}

extension DetailPresenter: DetailPresenterInterface {
    func checkButtons() {
        if gameDetails.website == nil || gameDetails.website == "" {
            view?.setVisitWebsiteButtonVisibility(isHidden: true)
        }
        if gameDetails.reddit_url == nil || gameDetails.reddit_url == "" {
            view?.setVisitRedditButtonVisibility(isHidden: true)
        }
    }
    
    func descriptionTextTapped(numberOfLines: Int) {
        if (numberOfLines == 0) {
            view?.setDescriptionTextLength(numberOfLines: 4)
        }
        else {
            view?.setDescriptionTextLength(numberOfLines: 0)
        }
    }
    
    func redditButtonTapped() {
        UIApplication.shared.open(URL(string: gameDetails.reddit_url!)!)
        print("Clicked to Reddit Button")
    }
    
    func websiteButtonTapped() {
        UIApplication.shared.open(URL(string: gameDetails.website!)!)
        print("Clicked to Website Button")
    }
    
    func wishlistButtonTapped() {
        /*
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
        */
    }
    
    func viewDidLoad() {
        view?.startAnimating()
        view?.setupUI()
        checkButtons()
        interactor.getSingleGameDetails(requestedGameId: self.arguments.gameId)
        
        checkIfTheGameIsWishlisted()
        
        NotificationCenter.shared.notifyObserversAboutViewedGame(gameId: self.gameId)
        
    }
}

extension DetailPresenter: DetailInteractorInterfaceOutput {
    func handleSingleGameDetails(result: GameResult) {
        switch result {
        case .success(let response):
            self.gameDetails = response
            DispatchQueue.main.async { [weak self] in
                self?.setupUI()
                self?.view?.stopAnimating()
            }
        case .failure(let error):
            print("Error while handling single game details on DetailPresenter. \(error.localizedDescription) ")
        }
    }
}
