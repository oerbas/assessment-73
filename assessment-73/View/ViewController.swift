//
//  ViewController.swift
//  assessment-73
//
//  Created by Orhan Erbas on 3.04.2021.
//

import UIKit
import Kingfisher
import DropDown

class ViewController: UIViewController {
    
//  MARK: -Variables-
    @IBOutlet weak var firstTableView: UITableView!
    @IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var buttonsBack: UIView!
    @IBOutlet weak var buttonGrid: UIButton!
    @IBOutlet weak var buttonList: UIButton!
    @IBOutlet weak var gridViewer: UIView!
    @IBOutlet weak var filterBySpecies: UIButton!
    
    private var CharacterListModel : CharacterListViewModel!

    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    var resultArray : [Character] = Array()
    var charId : Int!
    var nextPage : String!
    var arrayFavs : [Bool] = []
    
//  MARK: -DropDown Menu-
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Alive", "Dead", "Unknown"]
        menu.cellNib = UINib(nibName: "SpeciesDropDownCell", bundle: nil)
        menu.customCellConfiguration = { index, title, cell in
            guard let cell = cell as? SpeciesDropDownCell else {
                return
            }
        }
        return menu
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateData()
    }

    func updateData() {
        HomeService.instance.getCharacterList(success: { result in
            self.CharacterListModel = CharacterListViewModel(characterlist: result!)
            self.resultArray.append(contentsOf: self.CharacterListModel.characterlist.results)
            var storedIDs : [String] = []
            if let data = UserDefaults.standard.value(forKey: "favs_id") {
                storedIDs = data as! [String]
            }
            self.arrayFavs.removeAll()
            for idx in 0...self.resultArray.count - 1{
                if storedIDs.contains(String(self.resultArray[idx].id)) {
                    self.arrayFavs.append(true)
                }else{
                    self.arrayFavs.append(false)
                }
            }
            DispatchQueue.main.async {
                self.nextPage = result?.info.next
                self.firstTableView.reloadData()
                self.spinner.stopAnimating()
                self.gridCollectionView.reloadData()
            }
        })
    }
    
    @IBAction func buttonGridAction(_ sender: Any) {
        self.buttonList.isHidden = false
        self.buttonGrid.isHidden = true
        self.gridViewer.isHidden = false
        self.gridCollectionView.isHidden =  false
        self.firstTableView.isHidden = true
    }
    
    @IBAction func buttonTableAction(_ sender: Any) {
        self.buttonList.isHidden = true
        self.buttonGrid.isHidden = false
        self.gridViewer.isHidden = true
        self.gridCollectionView.isHidden =  true
        self.firstTableView.isHidden = false
    }
 
//  Setup View and DropDown
    func setupView() {
        updateData()
        firstTableView.delegate = self
        firstTableView.dataSource = self
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        buttonsBack.layer.cornerRadius = 12
        buttonGrid.isHidden = false
        buttonList.isHidden = true
        gridViewer.isHidden = true
        gridCollectionView.isHidden = true
        filterBySpecies.layer.cornerRadius = 12
        menu.anchorView = self.filterBySpecies
        
        let Gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem))
        
        filterBySpecies.addGestureRecognizer(Gesture)
        
        //Register DropDownMenu
        menu.selectionAction = { index, title in
            switch index {
            case 0:
                self.resultArray = []
                Constants.baseUrl = "\(Constants.consBaseUrl)?status=alive"
                self.updateData()
            case 1:
                self.resultArray = []
                Constants.baseUrl = "\(Constants.consBaseUrl)?status=dead"
                self.updateData()
            case 2:
                self.resultArray = []
                Constants.baseUrl = "\(Constants.consBaseUrl)?status=unknown"
                self.updateData()
            default:
                print("Default Value Clicked")
            }
        }
    }
    
    @objc func didTapTopItem() {
        menu.show()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "charDetail" {
            let vc = segue.destination as? ProductDetailViewController
            vc!.charId = self.charId
        }
    }
}

// MARK: -TableView Delegate, DataSource -
extension ViewController : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewControllerTableViewCell", for: indexPath) as! ViewControllerTableViewCell
        cell.firstImageView.layer.cornerRadius = 12
        cell.firstImageView.kf.setImage(with: self.resultArray[indexPath.row].imagePath())
        cell.firstLabel.text = self.resultArray[indexPath.row].status
        cell.secondLabel.text = self.resultArray[indexPath.row].name
        cell.thirtLabel.text = self.resultArray[indexPath.row].species
        cell.chId = String(self.resultArray[indexPath.row].id)
        
        if self.arrayFavs[indexPath.row] {
            cell.favsButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        } else {
            cell.favsButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        }
        
        cell.favsButton.tag = indexPath.row
        cell.favsButton.addTarget(self,action:#selector(faveBtnClicked),
                                  for:.touchUpInside)
        return cell
    }
    
    @objc func faveBtnClicked(sender:UIButton) {
        let chId = String(self.resultArray[sender.tag].id)
        Globals.shared.localFavs.append(chId)
        UserDefaults.standard.setValue(Globals.shared.localFavs, forKey: "favs_id")
    
        self.arrayFavs[sender.tag] = true
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        self.firstTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            self.firstTableView.tableFooterView = spinner
            self.firstTableView.tableFooterView?.isHidden = false
            self.spinner.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.firstTableView.tableFooterView?.isHidden = true
                self.spinner.stopAnimating()
                if self.nextPage != nil {
                    Constants.baseUrl = self.nextPage
                    self.updateData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.charId = self.resultArray[indexPath.row].id
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "charDetail", sender: nil)
        }
    }
}


// MARK: -CollectionView Delegate, DataSource-
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.resultArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCollectionViewCell", for: indexPath) as! GridViewCollectionViewCell
        cell.firstImageView.layer.cornerRadius = 12
        cell.firstImageView.kf.setImage(with: self.resultArray[indexPath.row].imagePath())
        cell.nameLabel.text = self.resultArray[indexPath.row].name
        cell.statusLabel.text = self.resultArray[indexPath.row].status
        cell.speciesLabel.text = self.resultArray[indexPath.row].species
        cell.chId = String(self.resultArray[indexPath.row].id)
        
        if self.arrayFavs[indexPath.row] {
            cell.addFavouriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        } else {
            cell.addFavouriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        }
        
        cell.addFavouriteButton.tag = indexPath.row
        cell.addFavouriteButton.addTarget(self,action:#selector(faveBtnClicked),
                                  for:.touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastRowIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            Constants.baseUrl = self.nextPage ?? ""
            updateData()
        }
   }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.charId = self.resultArray[indexPath.row].id
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "charDetail", sender: nil)
        }
    }
}

