//
//  ProductDetailViewController.swift
//  assessment-73
//
//  Created by Orhan Erbas on 4.04.2021.
//

import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productStatus: UILabel!
    @IBOutlet weak var productSpecies: UILabel!
    @IBOutlet weak var numberOfEpsodes: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var lastLocationName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var CharacterDetailModel : CharacterDetailViewModel!
    var charId : Int!    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.productImage.layer.cornerRadius = 15
        collectionView.delegate = self
        collectionView.dataSource = self
        loadData()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Globals.shared.resultEpisode = []
    }
    
    func loadData() {
        let storedPlayers = UserDefaults.standard.object(forKey: "favs_id")
        if let storedPlayer = storedPlayers as? Array<Any> {
            for item in storedPlayer {
                if charId == Int(item as! String) {
                    favoriteButton.setImage( UIImage(systemName: "suit.heart.fill"), for: .normal)
                }
            }
        }
        
        HomeService.instance.getCharDetail(chId: self.charId, success: { result in
            self.CharacterDetailModel = CharacterDetailViewModel(result: result!)
            DispatchQueue.main.async {
                self.productImage.kf.setImage(with: self.CharacterDetailModel.image)
                self.productName.text = self.CharacterDetailModel.name
                self.productStatus.text = self.CharacterDetailModel.status
                self.productSpecies.text = "Species :   \(self.CharacterDetailModel.species)"
                self.numberOfEpsodes.text = "Number Of Episodes :    \(String(self.CharacterDetailModel.numberOfepisode))"
                self.gender.text = "Gender :   \(self.CharacterDetailModel.gender)"
                self.locationName.text = "Location Name :   \(self.CharacterDetailModel.locationName)"
                self.lastLocationName.text = "Last Location : \(self.CharacterDetailModel.lastKnownLocationName)"
            }
            
            for episodeUrl in self.CharacterDetailModel.episode {
                HomeService.instance.getEpisode(url: episodeUrl, success: { result in
                    Globals.shared.resultEpisode.append(result!)
                })
            }
        })
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        Globals.shared.localFavs.append(String(charId))
        UserDefaults.standard.set(Globals.shared.localFavs, forKey: "favs_id")
        favoriteButton.setImage( UIImage(systemName: "suit.heart.fill"), for: .normal)
        UserDefaults.standard.synchronize()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Globals.shared.resultEpisode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodeViewCell", for: indexPath) as! EpisodeCollectionViewCell
            cell.name.text = Globals.shared.resultEpisode[indexPath.row].name
            cell.date.text = Globals.shared.resultEpisode[indexPath.row].air_date
        return cell
    }
    
}
