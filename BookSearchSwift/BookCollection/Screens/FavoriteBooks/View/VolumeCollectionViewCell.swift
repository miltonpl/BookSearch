//
//  VolumeCollectionViewCell.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 11/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit
protocol VolumeCollectionViewCellDelegate: AnyObject {
    func removeVolume(studentId: Int32)
}

class VolumeCollectionViewCell: UICollectionViewCell {
    weak var delegate: VolumeCollectionViewCellDelegate?
    static let identifier = "VolumeCollectionViewCell"
    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            self.containerView.layer.borderWidth  = 1.0
            self.containerView.layer.cornerRadius = 14
        }
    }
    var studentId: Int32?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "VolumeCollectionViewCell", bundle: nil)
    }
    
    func configure(model: CellModelProtocol) {
        self.titleLabel.text = model.title
        self.subtitleLabel.text = model.title
        self.studentId = model.studentId
        guard let url = model.url else { return }
        self.bookImageView.downloadImage(with: url)
    }
    
    @IBAction func removeAction(_ sender: UIButton) {
        print("tap removed")
        guard let studentId = self.studentId else { return }
        self.delegate?.removeVolume(studentId: studentId)
    }
    
}
