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

    func setStackViewVisibility(isHidden: Bool)
    
    func setBackgroundPhoto(photoUrl: URL)
    func setBackgroundPhotoVisibility(isHidden: Bool)
    
    func changeGameTitle(text: String)
    func setGameTitleVisibility(isHidden: Bool)
    
    func changeDescriptionText(text: String)
    func setDescriptionTextLength(numberOfLines: Int)
    func setDescriptionTextVisibility(isHidden: Bool)
    
    func changeReleaseDateText(text: String)
    func setReleaseDateTextVisibility(isHidden: Bool)
    
    func changeGenreSectionText(text: String)
    func setGenreSectionVisibility(isHidden: Bool)
    
    func changePublishersSectionText(text: String)
    func setPublishersSectionVisibility(isHidden: Bool)
    
    func setMetacriticSection(text: String, color: UIColor)
    func setMetacriticSectionVisibility(isHidden: Bool)
    
    func changePlaytimeSectionText(text: String)
    func setPlaytimeSectionVisibility(isHidden: Bool)

    func changeNavBarButtonColor(color: UIColor)
    
    func setVisitWebsiteButtonVisibility(isHidden: Bool)
    func setVisitRedditButtonVisibility(isHidden: Bool)
        
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
     
    /*
    // ui ayarlamarı -async yerde ama-
    func setUI() {
        if (publishersSection.isHidden == true &&
            genresSection.isHidden == true &&
            releaseDateSection.isHidden == true &&
            playtimeSection.isHidden == true) {
            informationsSection.isHidden = true
        }
        checkButtons()
    }
    
    // reddit tuşu ve website tuşu açıp kapamalarını yapıyorum
    func checkButtons() {
        presenter.checkButtons()
    }
     */
}

extension DetailViewController: DetailViewInterface {
    func setStackViewVisibility(isHidden: Bool) {
        stackView.isHidden = isHidden
    }
    
    func setBackgroundPhotoVisibility(isHidden: Bool) {
        backgroundImage.isHidden = isHidden
    }
    
    func setGameTitleVisibility(isHidden: Bool) {
        gameTitleLabel.isHidden = isHidden
    }
    
    func setReleaseDateTextVisibility(isHidden: Bool) {
        releaseDateText.isHidden = isHidden
    }
    
    func setMetacriticSectionVisibility(isHidden: Bool) {
        metacriticRating.isHidden = isHidden
    }
    
    func setVisitWebsiteButtonVisibility(isHidden: Bool) {
        visitWebsiteView.isHidden = isHidden
    }
    
    func setVisitRedditButtonVisibility(isHidden: Bool) {
        visitRedditView.isHidden = isHidden
    }
    
    func changeReleaseDateText(text: String) {
        releaseDateText.text = text
    }
    
    func setBackgroundPhoto(photoUrl: URL) {
        backgroundImage.kf.setImage(with: photoUrl)
    }
    
    func changeGameTitle(text: String) {
        gameTitleLabel.text = text
    }
    
    func changeDescriptionText(text: String) {
        descriptionText.text = text
    }
    
    func setDescriptionTextLength(numberOfLines: Int) {
        descriptionText.numberOfLines = numberOfLines
    }
    
    func setDescriptionTextVisibility(isHidden: Bool) {
        descriptionText.isHidden = isHidden
    }
    
    func changeGenreSectionText(text: String) {
        genresText.text = text
    }
    
    func setGenreSectionVisibility(isHidden: Bool) {
        genresText.isHidden = isHidden
    }
    
    func changePublishersSectionText(text: String) {
        publishersText.text = text
    }
    
    func setPublishersSectionVisibility(isHidden: Bool) {
        publishersText.isHidden = isHidden
    }
    
    func setMetacriticSection(text: String, color: UIColor) {
        metacriticRating.text = text
        metacriticRating.textColor = color
        metacriticRating.layer.borderColor = color.cgColor
    }
    
    func changePlaytimeSectionText(text: String) {
        playtimeText.text = text
    }
    
    func setPlaytimeSectionVisibility(isHidden: Bool) {
        playtimeText.isHidden = isHidden
    }
    
    func changeNavBarButtonColor(color: UIColor) {
        navBarWishlistButton.tintColor = color
    }
    
    func setupUI() {
        addTapGestures()
        
        metacriticRating.layer.borderWidth = 0.5
        metacriticRating.layer.cornerRadius = 4
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}

