//
//  HomeService.swift
//  assessment-73
//
//  Created by Orhan Erbas on 3.04.2021.
//

import Foundation
import Alamofire

class HomeService {
    
    static let instance = HomeService()
    private init() { }
    
    func getCharacterList(success successCallback: @escaping (CharacterList?) -> Void){
        let request = AF.request(Constants.baseUrl)
        request.responseDecodable(of: CharacterList.self) { (response) in
          guard let upcoming = response.value else { return }
          DispatchQueue.main.async {
             successCallback(upcoming)
          }
        }
    }
    
    func getCharDetail(chId: Int,success successCallback: @escaping (Character?) -> Void){
        let request = AF.request("\(Constants.consBaseUrl)\(chId)")
        request.responseDecodable(of: Character.self) { (response) in
          guard let upcoming = response.value else { return }
          DispatchQueue.main.async {
             successCallback(upcoming)
          }
        }
    }
    
    func getEpisode(url: String,success successCallback: @escaping (Episode?) -> Void){
        let request = AF.request(url)
        request.responseDecodable(of: Episode.self) { (response) in
          guard let upcoming = response.value else { return }
          DispatchQueue.main.async {
            successCallback(upcoming)
          }
        }
    }
}
