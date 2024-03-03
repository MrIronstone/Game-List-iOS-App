//
//  FilterCell.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 24.07.2022.
//

import Foundation
import UIKit


extension FilterCell {
    private enum Colors {
        enum FilterCellColor {
            static let grayColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        }
    }
}

protocol FilterCellInterface: AnyObject {
    func setPlatformTitle(_ title: String)
    func setAsSelected()
    func setAsUnselected()
}

class FilterCell: UICollectionViewCell {
    static let identifier: String = "FilterCell"
    
    @IBOutlet weak var platformLabel: UILabel!
    
    private var presenter: FilterCellPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    func configure(presenter: FilterCellPresenterInterface) {
        self.presenter = presenter
    }
}

extension FilterCell: FilterCellInterface {
    func setAsSelected() {
        backgroundColor = .white
        platformLabel.textColor = Colors.FilterCellColor.grayColor
    }
    
    func setAsUnselected() {
        backgroundColor = Colors.FilterCellColor.grayColor
        platformLabel.textColor = .white
    }
    
    func setPlatformTitle(_ title: String) {
        platformLabel.text = title
    }
}
