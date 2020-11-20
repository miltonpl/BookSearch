// ListTableViewCell.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//
import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView! {
        didSet {
//            bookImageView.layer.cornerRadius = bookImageView.frame.width/8
            bookImageView.layer.borderWidth = 2
            bookImageView.layer.borderColor = UIColor.black.cgColor
            bookImageView.layer.backgroundColor = UIColor.green.cgColor
            bookImageView.contentMode = .scaleToFill
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func setProterties( item: VolumeInfo) {
       
        titleLabel.text = item.title
        titleLabel.numberOfLines = 0
        subtitleLabel.text = item.subtitle
        titleLabel.numberOfLines = 0
        subtitleLabel.isHidden = item.subtitle?.isEmpty ?? true
        
        guard let thumbNail = item.imageLinks?.smallThumbnail, let url = URL(string: thumbNail) else { return }
        self.bookImageView.downloadImage(with: url)
    }
    
    func configure(model: CellModelProtocol) {
        titleLabel.text = model.title
        titleLabel.numberOfLines = 0
        subtitleLabel.text = model.subtitle
        titleLabel.numberOfLines = 0
        subtitleLabel.isHidden = model.subtitle?.isEmpty ?? true
        if let url = model.url {
            self.bookImageView.downloadImage(with: url)
        }
    }
}
