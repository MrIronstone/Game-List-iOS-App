//
//  FilterCell.swift
//  GameListAppWithUIKit
//
//  Created by Hüsamettin Demirtaş on 24.07.2022.
//

import Foundation
import UIKit

class FilterCell: UICollectionViewCell {
    
    var filterId = 1
    
    @IBOutlet weak var platformLabel: UILabel!
    
    func setLabel(label:String) {
        platformLabel.text = label
        platformLabel.textColor = .white
    }
    
    func setFilterId(id:Int) {
        filterId = id
    }
}
