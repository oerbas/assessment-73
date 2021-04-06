//
//  GridViewCollectionViewCell.swift
//  assessment-73
//
//  Created by Orhan Erbas on 4.04.2021.
//

import UIKit

class GridViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addFavouriteButton: UIButton!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    
    var chId: String!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(favOnClicked))
        self.addFavouriteButton.addGestureRecognizer(gesture)
    }

    
    @objc func favOnClicked() {
        print("orhan", chId)
        Globals.shared.localFavs.append(chId!)
        UserDefaults.standard.set(Globals.shared.localFavs, forKey: "favs_id")
        addFavouriteButton.setImage( UIImage(systemName: "suit.heart.fill"), for: .normal)
        UserDefaults.standard.synchronize()
    }
}
