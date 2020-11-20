//
//  UIImageView+Ext.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 11/16/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
extension UIImageView {
    
    func downloadImage(with url: URL) {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .red
        indicator.startAnimating()
        indicator.center = self.center
        self.addSubview(indicator)
        DispatchQueue.global().async {
            do {
                let data  = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
            } catch {
                print(error)
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
