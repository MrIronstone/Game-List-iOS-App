//
//  CollectionViewController.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 7.07.2022.
//

/*

import UIKit

class HomeCollectionViewController: UICollectionViewController {
    
    var homePresenterObject: ViewToPresenterHomeProtocol?
    
    var gameList = RawgGamesResponse(count: 0, previous: "", results: [], next: "")
    var currentPage = 0
    
    
    override func viewDidLoad() {
        // assignments
        HomeRouter.execModule(ref: self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        super.viewDidLoad()
    }

    // ekranda 2 column olması için
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = CollectionViewCell()
        let width = (view.frame.size.width - 20 ) / 2
        return CGSize(width: width, height: cell.frame.height)
      }
    
    override func viewWillAppear(_ animated: Bool) {
        homePresenterObject?.viewGames(requestedPage: currentPage + 1)
    }
    
    // detail view için
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        let gameInformation = gameList.results![indexPath.row]
        
        // isim ayarlamak için
        vc?.gameDetails = gameInformation
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    // toplam hücre sayısı için
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print("numberOfSections: ", gameList.results!.count)
        return gameList.results!.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if let gameCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            
            let tempCell = self.gameList.results![indexPath.row]

            gameCell.setLabel(gameName: tempCell.name!)
            
            gameCell.setPhoto(photoUrl: tempCell.background_image!)
            
            cell = gameCell
        }
        
        return cell
    }
    
}

extension HomeCollectionViewController: PresenterToViewHomeProtocol{
    func sendDataToView(gameList: RawgGamesResponse) {
        DispatchQueue.main.async {
            self.gameList = gameList
            self.collectionView.reloadData()
        }
    }
}

 */
