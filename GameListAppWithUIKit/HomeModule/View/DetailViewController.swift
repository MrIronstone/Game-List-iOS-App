//
//  DetailViewController.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 8.07.2022.
//

import UIKit

protocol WishlistButtonDelegate: AnyObject {
    func didTapWishlistButton(gameId:Int, isWishlisted:Bool)
}

class DetailViewController: UIViewController {

    var homePresenterObject: ViewToPresenterHomeProtocol?
    
    var cvCellRef: CollectionViewCell?
        
    var gameId:Int = 0
    
    var wishlistButtonDelegate: WishlistButtonDelegate!
    
    let greenColor = UIColor(red: 93.0/255.0, green: 197.0/255.0, blue: 52.0/255.0, alpha: 1.0)
    let grayColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    @IBOutlet weak var metacriticRating: UILabel!
            
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var descriptionTextView: UIView!
    
    @IBOutlet weak var informationsSection: UIView!
    
    @IBOutlet weak var releaseDateSection: UIStackView!
    @IBOutlet weak var releaseDateText: UILabel!
    
    @IBOutlet weak var genresSection: UIStackView!
    @IBOutlet weak var genresText: UILabel!
    
    @IBOutlet weak var playtimeSection: UIStackView!
    @IBOutlet weak var playtimeText: UILabel!
    
    @IBOutlet weak var publishersSection: UIStackView!
    @IBOutlet weak var publishersText: UILabel!
    
    @IBOutlet weak var visitRedditView: UIView!
    @IBOutlet weak var visitWebsiteView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var navBarWishlistButton: UIButton!
    
    @IBAction func navBarWishlist(_ sender: UIButton) {
        if(homePresenterObject!.isThisGameWishlisted(gameId: self.gameId)){
            homePresenterObject?.removeGameFromWishlist(requestedGameId: self.gameId)
            navBarWishlistButton.tintColor = .white
            
            // bir önceki ekranda wishlit butonu rengi değiştirmek için delegate
            //wishlistButtonDelegate.didTapWishlistButton(gameId: self.gameId, isWishlisted: false)
            
            // tüm ekranlardaki hücrelerde wishlist tuşu rengi değiştirmek için
            NotificationCenter.shared.notifyObserversAboutUnWishlist(gameId: self.gameId)
            
            // wishlist ekranında liste değişimi için bilgi
            NotificationCenter.shared.notifyWishlistScreenAboutChanges()
            
        } else {
            homePresenterObject?.addGameToWishlist(requestedGameId: self.gameId)
            navBarWishlistButton.tintColor = greenColor
            
            // bir önceki ekranda wishlist tuşu ekranı değiştmek için delegate
            //wishlistButtonDelegate.didTapWishlistButton(gameId: self.gameId, isWishlisted: true)
            
            // tüm ekranlardaki hücrelerde wishlist tuşu rengi değiştirmek için
            NotificationCenter.shared.notifyObserverAboutWishlist(gameId: self.gameId)
            
            // wishlist ekranında liste değişimi için bilgi
            NotificationCenter.shared.notifyWishlistScreenAboutChanges()
        }
    }
    
    
    var gameDetails = RawgGameResponse(id: 0, name: "", description_raw: "", released: "", metacritic: 0.0, playtime: 0, genres: [], parent_platforms: [], publishers: [], background_image: "", reddit_url: "", website: "")
    
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        
        HomeRouter.execDetailModule(ref: self)
        
        homePresenterObject?.viewGameDetails(requestedGameId: self.gameId)
    
        // buton atamaları
        
        let tapOfDescription = UITapGestureRecognizer(target: self, action: #selector(self.handleDescriptionText(_:)))

        descriptionTextView.addGestureRecognizer(tapOfDescription)
        
        let tapOfReddit = UITapGestureRecognizer(target: self, action: #selector(self.handleRedditButton(_:)))

        visitRedditView.addGestureRecognizer(tapOfReddit)
        
        let tapOfWebsite = UITapGestureRecognizer(target: self, action: #selector(self.handleWebsiteButton(_:)))

        visitWebsiteView.addGestureRecognizer(tapOfWebsite)
        
        checkIfTheGameIsWishlisted()
        
        NotificationCenter.shared.notifyObserversAboutViewedGame(gameId: self.gameId)
        
        super.viewDidLoad()

    }
    
    // description alanına tıklama fonksiyonu
    @objc func handleDescriptionText(_ sender: UITapGestureRecognizer? = nil) {
        if ( descriptionText.numberOfLines == 0) {
            descriptionText.numberOfLines = 4
        }
        else {
            descriptionText.numberOfLines = 0
        }
    }
    
    // reddit butonu tıklama fonksiyonu
    @objc func handleRedditButton(_ sender: UITapGestureRecognizer? = nil) {
        if(!visitRedditView.isHidden) {
            UIApplication.shared.open(URL(string: gameDetails.reddit_url!)!)
            print("Clicked to Reddit Button")
        }
    }
    
    // website butonu için tıklama fonkisyonu
    @objc func handleWebsiteButton(_ sender: UITapGestureRecognizer? = nil) {
        if(!visitWebsiteView.isHidden) {
            UIApplication.shared.open(URL(string: gameDetails.website!)!)
            print("Clicked to Website Button")
        }
    }
    
    // açılan oyunun wishlistte olup olmadığını kontrol edip ona göre navBar'daki tuşu boyuyor
    // bunu bu view ilk açıldığında kullanıyorum sadece
    func checkIfTheGameIsWishlisted() {
        if(homePresenterObject!.isThisGameWishlisted(gameId: gameId)) {
            navBarWishlistButton.tintColor = greenColor
        } else {
            navBarWishlistButton.tintColor = .white
        }
    }
    
    // ui ayarlamarı -async yerde ama-
    func setUI() {
        
        gameTitleLabel.text = gameDetails.name
        
        
        descriptionText.text = gameDetails.description_raw
        
        if( descriptionText.text == "") {
            descriptionTextView.isHidden = true
        }
        
        // description
        let url = URL(string: gameDetails.background_image!)
        let data = try? Data(contentsOf: url!)
        backgroundImage.image = UIImage(data: data!)
    
        releaseDateText.text = gameDetails.released
        setGenresSection(genresArray: gameDetails.genres ?? [Genre]())
        setPlaytimeSection(playtime: gameDetails.playtime ?? 0)
        setPublishersSection(publishersArray: gameDetails.publishers ?? [Publisher]())
        
        if (publishersSection.isHidden == true &&
            genresSection.isHidden == true &&
            releaseDateSection.isHidden == true &&
            playtimeSection.isHidden == true) {
            informationsSection.isHidden = true
        }
        
        MetacriticRating(rating: gameDetails.metacritic ?? 0.0)
     
        checkButtons()
    }
    
    // reddit tuşu ve website tuşu açıp kapamalarını yapıyorum
    func checkButtons() {
        if gameDetails.website == nil || gameDetails.website == "" {
            visitWebsiteView.isHidden = true
        }
        if gameDetails.reddit_url == nil || gameDetails.reddit_url == "" {
            visitRedditView.isHidden = true
        }
    }
    
    func setPublishersSection (publishersArray:[Publisher]) {
        if publishersArray.count != 0 {
            var publishers: [String] = []
            for publisher in publishersArray {
                publishers.append(publisher.name!)
            }
            
            publishersText.text = publishers.joined(separator: ", ")
            
        } else {
            publishersSection.isHidden = true
        }
    }
    
    func setGenresSection (genresArray:[Genre]) {
        
        if genresArray.count != 0 {
            var genres: [String] = []
            for genre in genresArray {
                genres.append(genre.name!)
            }
            
            genresText.text = genres.joined(separator: ", ")
        } else {
            genresSection.isHidden = true
        }
    }
    
    func setPlaytimeSection (playtime: Int) {
        if playtime == 0 {
            playtimeSection.isHidden = true
        } else {
            playtimeText.text = "\(playtime) hours"
        }
    }
    
    func MetacriticRating (rating:Double) {
        
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
    
    // sayfa ilk açılırken lorem ipsum görünmesin diye ui gizli, set işlemleri bitince geri açmak için
    func MakeUIVisible(){
        backgroundImage.isHidden = false
        gameTitleLabel.isHidden = false
        metacriticRating.isHidden = false
        stackView.isHidden = false
    }
}

extension DetailViewController: PresenterToDetailViewHomeProtocol {

    func sendGameDetails(gameDetails: RawgGameResponse) {
        DispatchQueue.main.async {
            self.gameDetails = gameDetails
            self.setUI()
            self.MakeUIVisible()
            self.activityIndicator.stopAnimating()
            
        }
    }
    

}

