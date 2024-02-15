//
//  CollectionViewCell.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 1.07.2022.
//

import UIKit
import Kingfisher

extension CollectionViewCell {
    private enum Colors {
        enum WishlistButtonColor {
            static let greenColor = UIColor(red: 93.0/255.0, green: 197.0/255.0, blue: 52.0/255.0, alpha: 1.0)
            static let grayColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
            static let viewedCellTitleColor = UIColor(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        }
    }
}

protocol CollectionViewCellInterface: AnyObject {
    func setGameTitle(_ title: String)
    func setBackgroundImage(_ photoUrl: String)
    func changeTitleColorToViewed()
    func assignButtonTag(gameId: Int)
    func changeFavButtonColorToGray()
    func changeFavButtonColorToGreen()
    func prepareUI()
}

final class CollectionViewCell: UICollectionViewCell {
    static let identifier: String = "CollectionViewCell"

    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var wishlistButton: UIButton!
    
    private var presenter: CollectionViewCellPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    func configure(presenter: CollectionViewCellPresenterInterface) {
        self.presenter = presenter
    }
    
    // TODO: bla bla
}

extension CollectionViewCell: CollectionViewCellInterface {
    func changeFavButtonColorToGray() {
        wishlistButton.backgroundColor = Colors.WishlistButtonColor.grayColor
    }
    
    func changeFavButtonColorToGreen() {
        wishlistButton.backgroundColor = Colors.WishlistButtonColor.greenColor
    }
    
    func assignButtonTag(gameId: Int) {
        wishlistButton.tag = gameId
    }
    
    func changeTitleColorToViewed() {
        self.gameTitle.textColor = Colors.WishlistButtonColor.viewedCellTitleColor
    }
    
    func setGameTitle(_ title: String) {
        gameTitle.text = title
    }
    
    func setBackgroundImage(_ photoUrl: String) {
        let url = URL(string: photoUrl)
        self.backgroundImage.kf.setImage(with: url)
    }
    
    func prepareUI() {
        gameTitle.textColor = .white
    }
}
