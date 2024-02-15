//
//  UIImageView+Extension.swift
//  GameListAppWithUIKit
//
//  Created by admin on 31.01.2024.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {
            NetworkEngine.session.dataTask(with: url) { (data, response, error) in
                guard let imageData = data else { return }
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: imageData)
                }
            }
            .resume()
        }
    }
    
    func load(urlString: String?) {
        DispatchQueue.global().async {
            if let urlString {
                if let url = URL(string: urlString) {
                    NetworkEngine.session.dataTask(with: url) { (data, response, error) in
                        guard let imageData = data else { return }
                        
                        DispatchQueue.main.async {
                            self.image = UIImage(data: imageData)
                        }
                    }
                    .resume()
                }
            }
        }
    }
}
