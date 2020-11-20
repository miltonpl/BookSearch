//
//  TableViewCell.swift
//  URLDataParsing
//
//  Created by Milton Palaguachi on 9/22/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet private weak var descriptionTextView: UITextView!
    static let identifier = "CustomTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setProperties(description: String) {
        descriptionTextView.text = description

    }
    static func nib() -> UINib {
             return UINib(nibName: "CustomTableViewCell", bundle: nil)
             
         }
    
}
