//
//  WishlistViewController.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 21.07.2022.
//

import UIKit

protocol WishlistViewInterface: AnyObject {
    func loadGames()
    func prepareUI()
}

extension WishlistViewController: WishlistViewInterface {
    func prepareUI() {
        // TODO: prepare ui
    }
    
    func loadGames() {
        collectionView.reloadData()
    }
    
}

extension WishlistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2 ) - 20
        let height = (width * (243/171)) - 10
        return CGSize(width: width , height: height )
    }
    
    // detail view için
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        guard let item = presenter.item(at: indexPath.row) else { return }
        
        // vc?.gameId = item.id
        
        // wishlist button delegate
        //vc?.wishlistButtonDelegate = self
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.changeTitleColorToViewed()
        }
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // toplam hücre sayısı için
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print("numberOfSections: ", gameList.results!.count)
        if presenter.numberOfItems == 0 && !activityIndicator.isAnimating {
            emptyViewLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyViewLabel.isHidden = true
            collectionView.isHidden = false
        }
        return presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let game = presenter.item(at: indexPath.row) {
            let presenter = CollectionViewCellPresenter(view: cell, game: game)
            cell.configure(presenter: presenter)
        }
        return cell
    }
}

class WishlistViewController: UIViewController { // WishlistView
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyViewLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: WishlistPresenterInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    @IBAction private func addAddressButtonAction(_ sender: UIButton) {
        presenter?.wishlistButtonTapped()
    }
    
    @IBAction func WishlistButton(_ sender: UIButton) {
        /*
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
         */
    }
}

/*
extension WishlistViewController: PresenterToWishlistViewHomeProtocol, WishlistButtonDelegate {
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
*/
