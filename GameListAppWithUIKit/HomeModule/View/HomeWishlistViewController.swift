//
//  HomeWishlistViewController.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 21.07.2022.
//

import UIKit


class HomeWishlistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WishlistView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var homePresenterObject: ViewToPresenterHomeProtocol?
    
    var gameList: [RawgGameResponse] = []
    
    @IBOutlet weak var emptyViewLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func WishlistButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Remove from Wishlist",
                                                message: "Are you sure you want to remove this game from wishlist?",
                                                preferredStyle: .alert)
        // Create OK button
        let OKAction = UIAlertAction(title: "Yes", style: .default) {
            (action: UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            self.homePresenterObject?.removeGameFromWishlist(requestedGameId: sender.tag)
            
            self.homePresenterObject?.viewWishlistedGames()

            // observer/notification pattern ile tüm hücrelere haber veriyorum
            NotificationCenter.shared.notifyObserversAboutUnWishlist(gameId: sender.tag)
            self.activityIndicator.startAnimating()
        }
        alertController.addAction(OKAction)
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (action: UIAlertAction!) in print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        // Present Dialog message
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    let greenColor = UIColor(red: 93.0/255.0, green: 197.0/255.0, blue: 52.0/255.0, alpha: 1.0)
    let grayColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
    
    
    override func viewDidLoad() {
        
        HomeRouter.execWishlistModule(ref: self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NotificationCenter.shared.wishlistView = self
        
        activityIndicator.startAnimating()
        homePresenterObject?.viewWishlistedGames()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    func fetchChanges() {
        homePresenterObject?.viewWishlistedGames()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2 ) - 20
        let height = (width * (243/171)) - 10
        return CGSize(width: width , height: height )
    }
    
    // detail view için
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        let id = gameList[indexPath.row].id
        
        vc?.gameId = id
        
        // wishlist button delegate
        vc?.wishlistButtonDelegate = self
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.setLabelGray()
        }
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // toplam hücre sayısı için
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print("numberOfSections: ", gameList.results!.count)
        if gameList.count == 0 && !activityIndicator.isAnimating {
            emptyViewLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyViewLabel.isHidden = true
            collectionView.isHidden = false
        }
        return gameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        // rasterize yapalım ki hızlı yüklensin
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        if let gameCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            
            let tempCell = self.gameList[indexPath.row]
            
            gameCell.gameId = tempCell.id
            
            
            // wishlist için
            gameCell.setButtonValue(gameId: tempCell.id)
            
            gameCell.setLabel(gameName: tempCell.name!)
            
            gameCell.checkIfItIsViewed()

            gameCell.setPhoto(photoUrl: tempCell.background_image!)
            
            gameCell.wishlistButton.backgroundColor = greenColor
            
            gameCell.subToNotificiations()
            
            cell = gameCell
        }
        return cell
    }
    
}

extension HomeWishlistViewController: PresenterToWishlistViewHomeProtocol, WishlistButtonDelegate {
    func didTapWishlistButton(gameId: Int, isWishlisted: Bool) {
        NotificationCenter.shared.wishlistView?.fetchChanges()
    }
    
    func sendAllGamesDataToView(gameList: [RawgGameResponse]) {
        DispatchQueue.main.async {
            self.gameList = gameList
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}

