//
//  CollectionViewCell.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 1.07.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, Observer {

    var gameId: Int = 0
    
    var viewedCell: [Int] = []
    
    let greenColor = UIColor(red: 93.0/255.0, green: 197.0/255.0, blue: 52.0/255.0, alpha: 1.0)
    let grayColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
    let viewedCellTitleColor = UIColor(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
            
    @IBOutlet weak var gameTitle: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var wishlistButton: UIButton!
    
    func setLabel(gameName:String) {
        gameTitle.text = gameName
        gameTitle.textColor = .white
    }
    
    func setPhoto(photoUrl:String) {
        
        let url = URL(string: photoUrl)
        if let safeUrl = url {
            let data = try? Data(contentsOf: safeUrl)
            if let safeData = data {
                backgroundImage.image = UIImage(data: safeData)
            }
        }
        
        // backgroundImage.loadFrom(UrlAdress: photoUrl)
    }
    
    func subToNotificiations(){
        NotificationCenter.shared.addObservers(observer: self)
    }
    
    // observer func
    func unWishlisted(gameId id: Int) {
        if self.gameId == id {
            wishlistButton.backgroundColor = grayColor
        }
    }
    
    func wishlist(gameId id: Int) {
        if self.gameId == id {
            wishlistButton.backgroundColor = greenColor
        }
    }
    
    // observer func
    func visitedGame(gameId id: Int) {
        if self.gameId == id {
            setLabelGray()
        }
    }
    
    func setLabelGray() {
        if !ViewedGames.shared.viewedGames.contains(gameId) {
            ViewedGames.shared.viewedGames.append(gameId)
        }
        self.gameTitle.textColor = viewedCellTitleColor
    }
    
    func checkIfItIsViewed() {
        if ViewedGames.shared.viewedGames.contains(self.gameId) {
            print("\(gameId) has been already viewed")
            self.gameTitle.textColor = viewedCellTitleColor
        }
    }
    
    
    func setButtonValue(gameId:Int) {
        wishlistButton.tag = gameId
    }
}
