//
//  CollectionViewController.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 7.07.2022.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var selectedPlatformFilter: String = ""
    var isFilterSelected: Bool = false
    var searchedWords: String = ""
    
    var homePresenterObject: ViewToPresenterHomeProtocol?
    
    var platformList = RawgPlatformsResponse(count: 0, previous: "", results: [], next: "")
    var gameList = RawgGamesResponse(count: 0, previous: "", results: [], next: "")
    var currentPage = 0
    var isPageRefreshing:Bool = false
    
    let greenColor = UIColor(red: 93.0/255.0, green: 197.0/255.0, blue: 52.0/255.0, alpha: 1.0)
    let grayColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
    
    let filterGrayColor = UIColor(red: 45.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1.0)
    
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var filterButtonsCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var emptyViewLabel: UILabel!
    
    @IBAction func WishlistGameButton(_ sender: UIButton) {
        if ( homePresenterObject!.isThisGameWishlisted(gameId: sender.tag)) {
            homePresenterObject!.removeGameFromWishlist(requestedGameId: sender.tag)
            sender.backgroundColor = grayColor
            
            NotificationCenter.shared.wishlistView?.fetchChanges()
            
            // wishlist ekranında liste değişimi için bilgi
            NotificationCenter.shared.notifyWishlistScreenAboutChanges()
            
        } else {
            homePresenterObject!.addGameToWishlist(requestedGameId: sender.tag)
            sender.backgroundColor = greenColor
            
            // wishlist ekranında liste değişimi için bilgi
            NotificationCenter.shared.notifyWishlistScreenAboutChanges()
            
            NotificationCenter.shared.wishlistView?.fetchChanges()
        }
    }
    
    override func viewDidLoad() {
        // assignments
        
        HomeRouter.execModule(ref: self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        filterButtonsCollectionView.delegate = self
        filterButtonsCollectionView.dataSource = self
        
        searchBar.delegate = self
        
        
        // ilk sayfayı yüklemek için
        homePresenterObject?.viewGamesBySearchText(searchText: searchedWords)
        
        // platfrom bilgilerini almak için
        homePresenterObject?.viewAllPlatforms()
        
        activityIndicator.startAnimating()
        
        super.viewDidLoad()
    }
    
    // bir komut aratılınca
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchedWords = searchBar.text ?? ""
        
        // ilk önce listeyi boşaltalım
        gameList = RawgGamesResponse(count: 0, previous: "", results: [], next: "")
        activityIndicator.startAnimating()
        homePresenterObject?.viewGamesBySearchText(searchText: searchedWords)
    }
    
    // her cihazda aynı olması için
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            let width = (collectionView.frame.width / 2 ) - 20
            let height = (width * (243/171)) - 10
            return CGSize(width: width , height: height )
        }
        // kontrol etmeyi unutma
        else if collectionView == filterButtonsCollectionView {
            let width = filterButtonsCollectionView.frame.width - 12
            let height = filterButtonsCollectionView.frame.height
            return CGSize(width: width, height: height)
        }
        return CGSize()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                // bu sayede crash yemeyi engelliyoruz
                guard let urlToNextPage = gameList.next else {
                    return
                }
                homePresenterObject?.loadNextPage(urlOfNextPage: urlToNextPage)
            }
        }
    }
    
    
    
    // detail view için
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
            
            let id = gameList.results![indexPath.row].id
            
            vc?.gameId = id
            
            vc?.wishlistButtonDelegate = self
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else if collectionView == filterButtonsCollectionView {
            if let cell = filterButtonsCollectionView.cellForItem(at: indexPath) as? FilterCell {
                if !isFilterSelected {
                    isFilterSelected = true
                    cell.platformLabel.textColor = filterGrayColor
                    cell.backgroundColor = .white
                    selectedPlatformFilter = String(cell.filterId)
                    print(selectedPlatformFilter)
                    // filter uygulama
                    gameList = RawgGamesResponse(count: 0, previous: "", results: [], next: "")
                    homePresenterObject?.viewGamesBySearchTextAndFilter(searchText: searchedWords, filter: selectedPlatformFilter)
                    activityIndicator.startAnimating()
                    
                } else if isFilterSelected && String(cell.filterId) == selectedPlatformFilter {
                    isFilterSelected = false
                    cell.backgroundColor = filterGrayColor
                    cell.platformLabel.textColor = .white
                    
                    // filtre kaldırma
                    gameList = RawgGamesResponse(count: 0, previous: "", results: [], next: "")
                    homePresenterObject?.viewGamesBySearchText(searchText: searchedWords)
                    activityIndicator.startAnimating()
                }
            }
        }
    }
    
    // toplam hücre sayısı için
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            // print("numberOfSections: ", gameList.results!.count)
            if gameList.results!.count == 0 && !activityIndicator.isAnimating {
                emptyViewLabel.isHidden = false
                collectionView.isHidden = true
            } else {
                emptyViewLabel.isHidden = true
                collectionView.isHidden = false
            }
            return gameList.results!.count
        }
        else if collectionView == filterButtonsCollectionView {
            // DO LOGIC
            return platformList.results!.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if collectionView == self.collectionView {
            // rasterize yapalım ki hızlı yüklensin
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            
            if let gameCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
                
                let tempCell = self.gameList.results![indexPath.row]
                
                gameCell.gameId = tempCell.id
                
                // wishlist için
                gameCell.setButtonValue(gameId: tempCell.id)
                
                // hücre üzerindeki yazı için
                gameCell.setLabel(gameName: tempCell.name!)
                
                // daha önce açılmış oyun olup olmadığını kontrol et
                gameCell.checkIfItIsViewed()
                
                // hücre üzerindeki fotoğraf için
                if let safePhotoURL = tempCell.background_image {
                    gameCell.setPhoto(photoUrl: safePhotoURL)
                } else {
                    gameCell.setPhoto(photoUrl: "https://i.im.ge/2022/07/24/FDVfKK.png")
                }
                // wishlist button arkaplanı için
                if ( homePresenterObject!.isThisGameWishlisted(gameId: tempCell.id)) {
                    gameCell.wishlistButton.backgroundColor = greenColor
                } else {
                    gameCell.wishlistButton.backgroundColor = grayColor
                }
                
                // wishliste abone ol
                gameCell.subToNotificiations()
                
                cell = gameCell
            }
        }
        else if collectionView == filterButtonsCollectionView {
            if let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCell {
                
                let tempFilterCell = self.platformList.results![indexPath.row]
            
                filterCell.setLabel(label: tempFilterCell.name ?? "N/A")
                
                filterCell.setFilterId(id: tempFilterCell.id ?? 1)
                
                cell = filterCell
            }
            
        }
        return cell
    }
    
}

extension HomeViewController: PresenterToViewHomeProtocol, WishlistButtonDelegate {
    func didTapWishlistButton(gameId: Int, isWishlisted: Bool) {
        let cellArray = self.collectionView.visibleCells as! [CollectionViewCell]
        for cell in cellArray {
            if cell.gameId == gameId {
                if isWishlisted {
                    cell.wishlistButton.backgroundColor = greenColor
                } else {
                    cell.wishlistButton.backgroundColor = grayColor
                    
                }
            }
        }
    }
    
    func sendAllGamesDataToView(gameList: RawgGamesResponse) {
        DispatchQueue.main.async {
            
            var oldGames:[RawgGameResponse]?
            var newGames:[RawgGameResponse]?
            
            oldGames = self.gameList.results
            newGames = gameList.results
            
            oldGames?.append(contentsOf: newGames!)
            
            let newList = RawgGamesResponse (count: gameList.count,
                                             previous: gameList.previous,
                                             results: oldGames,
                                             next: gameList.next)
            
            self.gameList = newList
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
            
            // yeni sayfa yükleme harici scroll bar'ı en tepeye alıyor müthiş güzel
            if(self.isPageRefreshing == false) {
                self.collectionView.setContentOffset(.zero, animated: true)
            }
            
            
            self.isPageRefreshing = false
        }
    }
    
    func sendAllPlatforms(platformList: RawgPlatformsResponse) {
        DispatchQueue.main.async {
            self.platformList = platformList
            self.filterButtonsCollectionView.reloadData()
        }
        
    }
}
