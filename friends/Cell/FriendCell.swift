//
//  FriendCell.swift
//  friends
//
//  Created by Faysal on 28/3/23.
//

import UIKit

class FriendCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .gray.withAlphaComponent(0.2)
        self.contentView.layer.cornerRadius = 8
    }

}
