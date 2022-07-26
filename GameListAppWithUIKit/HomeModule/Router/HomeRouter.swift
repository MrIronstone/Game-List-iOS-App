//
//  HomeRouter.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 8.07.2022.©
//

import Foundation

class HomeRouter: PresenterToRouterHomeProtocol {
    static func execModule(ref: HomeViewController) {
        let presenter = HomePresenter()
        
        
        // View kısmı
        ref.homePresenterObject = presenter
        
        // Presenter kısmı
        ref.homePresenterObject?.homeInteractorObject = HomeInteractor()
        ref.homePresenterObject?.homeViewObject = ref
        
        // Interactor
        ref.homePresenterObject?.homeInteractorObject?.homePresenterObject = presenter
    }
    
    static func execDetailModule(ref: DetailViewController) {
        let presenter = HomePresenter()
        
        ref.homePresenterObject = presenter
        
        
        ref.homePresenterObject?.homeInteractorObject = HomeInteractor()
        ref.homePresenterObject?.homeDetailViewObject = ref
        
        ref.homePresenterObject?.homeInteractorObject?.homePresenterObject = presenter
    }
    
    static func execWishlistModule(ref: HomeWishlistViewController) {
        let presenter = HomePresenter()
        
        ref.homePresenterObject = presenter
    
        ref.homePresenterObject?.homeInteractorObject = HomeInteractor()
        ref.homePresenterObject?.homeWishlistViewObject = ref
        
        ref.homePresenterObject?.homeInteractorObject?.homePresenterObject = presenter
    }
}
