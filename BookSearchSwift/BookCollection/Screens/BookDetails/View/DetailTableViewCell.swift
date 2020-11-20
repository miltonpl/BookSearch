//
//  DetailTableViewCell.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 11/16/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    static let identifier = "DetailTableViewCell"
    @IBOutlet private weak var typeLabe: UILabel!
    @IBOutlet private weak var infoLabe: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "DetailTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func configure(model: CellModelProtocol) {
        self.infoLabe.text = model.subtitle
        self.typeLabe.text = model.title
    }
}
