//
//  DetailViewController.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 8.07.2022.
//

import UIKit

/*
protocol WishlistButtonDelegate: AnyObject {
    func didTapWishlistButton(gameId:Int, isWishlisted:Bool)
}
 */

protocol DetailViewInterface: AnyObject {
    func setupUI()
    
    func setBackgroundPhoto(photoUrl: URL)
    
    func changeGameTitle(text: String)
    
    func changeDescriptionText(text: String)
    func setDescriptionTextLength(numberOfLines: Int)
    func setDescriptionTextVisibility(isHidden: Bool)
    
    func changeReleaseDateText(text: String)
    
    func changeGenreSectionText(text: String)
    func setGenreSectionVisibility(isHidden: Bool)
    
    func changePublishersSectionText(text: String)
    func setPublishersSectionVisibility(isHidden: Bool)
    
    func setMetacriticSection(text: String, color: UIColor)
    
    func changePlaytimeSectionText(text: String)
    func setPlaytimeSectionVisibility(isHidden: Bool)

    func changeNavBarButtonColor(color: UIColor)
        
    func startAnimating()
    func stopAnimating()
}

class DetailViewController: UIViewController {

    var presenter: DetailPresenterInterface!
    // var wishlistButtonDelegate: WishlistButtonDelegate!
    
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
        presenter.wishlistButtonTapped()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    func prepareUI() {
        addTapGestures()
    }
    
    func addTapGestures() {
        let tapOfDescription = UITapGestureRecognizer(target: self, action: #selector(self.handleDescriptionText(_:)))
        descriptionTextView.addGestureRecognizer(tapOfDescription)
        
        let tapOfReddit = UITapGestureRecognizer(target: self, action: #selector(self.handleRedditButton(_:)))
        visitRedditView.addGestureRecognizer(tapOfReddit)
        
        let tapOfWebsite = UITapGestureRecognizer(target: self, action: #selector(self.handleWebsiteButton(_:)))
        visitWebsiteView.addGestureRecognizer(tapOfWebsite)
    }
    
    // description alanına tıklama fonksiyonu
    @objc func handleDescriptionText(_ sender: UITapGestureRecognizer? = nil) {
        presenter.descriptionTextTapped(numberOfLines: descriptionText.numberOfLines)
    }
    
    // reddit butonu tıklama fonksiyonu
    @objc func handleRedditButton(_ sender: UITapGestureRecognizer? = nil) {
        presenter.redditButtonTapped()
    }
    
    // website butonu için tıklama fonkisyonu
    @objc func handleWebsiteButton(_ sender: UITapGestureRecognizer? = nil) {
        presenter.websiteButtonTapped()
    }
        
    // ui ayarlamarı -async yerde ama-
    func setUI() {
        
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
    
    // sayfa ilk açılırken lorem ipsum görünmesin diye ui gizli, set işlemleri bitince geri açmak için
    func MakeUIVisible(){
        backgroundImage.isHidden = false
        gameTitleLabel.isHidden = false
        metacriticRating.isHidden = false
        stackView.isHidden = false
    }
}

extension DetailViewController: DetailViewInterface {
    func changeReleaseDateText(text: String) {
        <#code#>
    }
    
    func setBackgroundPhoto(photoUrl: URL) {
        self.backgroundImage.kf.setImage(with: photoUrl)
    }
    
    func changeGameTitle(text: String) {
        self.gameTitleLabel.text = text
    }
    
    func changeDescriptionText(text: String) {
        <#code#>
    }
    
    func setDescriptionTextLength(numberOfLines: Int) {
        <#code#>
    }
    
    func setDescriptionTextVisibility(isHidden: Bool) {
        <#code#>
    }
    
    func changeGenreSectionText(text: String) {
        <#code#>
    }
    
    func setGenreSectionVisibility(isHidden: Bool) {
        <#code#>
    }
    
    func changePublishersSectionText(text: String) {
        <#code#>
    }
    
    func setPublishersSectionVisibility(isHidden: Bool) {
        <#code#>
    }
    
    func setMetacriticSection(text: String, color: UIColor) {
        <#code#>
    }
    
    func changePlaytimeSectionText(text: String) {
        <#code#>
    }
    
    func setPlaytimeSectionVisibility(isHidden: Bool) {
        <#code#>
    }
    
    func changeDescriptionTextLength(numberOfLines: Int) {
        <#code#>
    }
    
    func changeNavBarButtonColor(color: UIColor) {
        navBarWishlistButton.tintColor = color
    }
    
    func setupUI() {
        <#code#>
    }
    
    func startAnimating() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
}

