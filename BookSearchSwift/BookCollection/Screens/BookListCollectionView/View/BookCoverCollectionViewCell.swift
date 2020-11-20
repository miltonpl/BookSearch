//
//  BookCoverCollectionViewCell.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/27/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class BookCoverCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
  
    public func configure(model: CellModelProtocol) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        
        subtitleLabel.isHidden = model.subtitle?.isEmpty ?? true
        titleLabel.isHidden = model.title?.isEmpty ?? true
        if let url = model.url {
            self.imageView.downloadImage(with: url)
        }
    }
}
