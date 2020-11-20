//
//  DetailTableViewCell.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/22/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    func setupProperties(name: String, data: String) {
        nameLabel.text = name
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
        let myAttrString = NSAttributedString(string: data, attributes: myAttribute)
        descriptionLabel.attributedText = myAttrString
    }
}
