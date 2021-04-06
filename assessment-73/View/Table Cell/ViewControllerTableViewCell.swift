//
//  ViewControllerTableViewCell.swift
//  assessment-73
//
//  Created by Orhan Erbas on 3.04.2021.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
    
//  MARK:- Variables
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirtLabel: UILabel!
    @IBOutlet weak var favsButton: UIButton!
    
    var chId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(favOnClicked))
        self.favsButton.addGestureRecognizer(gesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func favOnClicked() {
        Globals.shared.localFavs.append(chId!)
        UserDefaults.standard.set(Globals.shared.localFavs, forKey: "favs_id")
        favsButton.setImage( UIImage(systemName: "suit.heart.fill"), for: .normal)
        UserDefaults.standard.synchronize()
    }

}
