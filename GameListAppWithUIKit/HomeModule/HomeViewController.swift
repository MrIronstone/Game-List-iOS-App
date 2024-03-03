//
//  CollectionViewController.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 7.07.2022.
//

import UIKit

extension HomeViewController {
    private enum Colors {
        enum wishlistButtonColor {
            static let greenColor = UIColor(red: 93.0/255.0, green: 197.0/255.0, blue: 52.0/255.0, alpha: 1.0)
            static let grayColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
            static let filterGrayColor = UIColor(red: 45.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1.0)
        }
    }
}

protocol HomeViewInterface: AnyObject {
    func setupUI()
    func loadGames()
    func loadPlatforms()
    
    func checkFilterCell(at index: IndexPath)
    func uncheckFiltercell(at index: IndexPath)
    
    func startAnimating()
    func stopAnimating()
}

class HomeViewController: UIViewController {
        
    var presenter: HomePresenterInterface!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterButtonsCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyViewLabel: UILabel!
    
    @IBAction func WishlistGameButton(_ sender: UIButton) {
        presenter.wishlistButtonTapped(with: sender.tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension HomeViewController: HomeViewInterface {
    func checkFilterCell(at index: IndexPath) {
        guard let cell = filterButtonsCollectionView.cellForItem(at: index) as? FilterCell else { return }
        cell.setAsSelected()
    }
    
    func uncheckFiltercell(at index: IndexPath) {
        guard let cell = filterButtonsCollectionView.cellForItem(at: index) as? FilterCell else { return }
        cell.setAsUnselected()
    }
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        filterButtonsCollectionView.delegate = self
        filterButtonsCollectionView.dataSource = self
        
        searchBar.delegate = self
    }
    
    func loadGames() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func loadPlatforms() {
        DispatchQueue.main.async { [weak self] in
            self?.filterButtonsCollectionView.reloadData()
        }
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

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.willDisplay(at: indexPath.row)
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
    
    // toplam hücre sayısı için
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            if presenter.numberOfGames == 0 && !activityIndicator.isAnimating {
                emptyViewLabel.isHidden = false
                collectionView.isHidden = true
            } else {
                emptyViewLabel.isHidden = true
                collectionView.isHidden = false
            }
            return presenter.numberOfGames
        }
        else if collectionView == filterButtonsCollectionView {
            // DO LOGIC
            return presenter.numberOfPlatforms
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()

        if collectionView == self.collectionView {

            guard let gameCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
                return UICollectionViewCell()
            }

            if let game = presenter.itemForGames(at: indexPath.row) {
                let presenter = CollectionViewCellPresenter(view: gameCell, game: game)
                gameCell.configure(presenter: presenter)
                cell = gameCell
            }
        }
        else if collectionView == filterButtonsCollectionView {
            if let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCell {

                if let filter = presenter.itemForPlatforms(at: indexPath.row) {
                    let presenter = FilterCellPresenter(view: filterCell, platform: filter)
                    filterCell.configure(presenter: presenter)
                    cell = filterCell
                }
            }
            
        }
        return cell
    }
    
    // detail view için
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            presenter.gameCellTapped(at: indexPath)
        }
        else if collectionView == filterButtonsCollectionView {
            if filterButtonsCollectionView.cellForItem(at: indexPath) is FilterCell {
                presenter.filterCellTapped(at: indexPath)
            }
        }
    }
}

// MARK: - Search Bar Delegate
extension HomeViewController: UISearchBarDelegate {
    // bir komut aratılınca
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchedWords = searchBar.text ?? ""
        presenter.searchBarSearchButtonClicked(text: searchedWords)
        // search yaptıktan sonra en üste çekmek için
        self.collectionView.setContentOffset(.zero, animated: true)
    }
}

