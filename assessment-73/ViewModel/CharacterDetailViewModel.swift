//
//  CharDetailModel.swift
//  assessment-73
//
//  Created by Orhan Erbas on 5.04.2021.
//

import Foundation

struct CharacterDetailViewModel {
    let result : Character
    
    var image : URL {
        return result.imagePath()!
    }
    
    var name : String {
        return result.name!
    }
    
    var status : String {
        return result.status!
    }
    
    var species : String {
        return result.species!
    }
    
    var numberOfepisode : Int {
        return result.episode.count
    }
    
    var gender : String {
        return result.gender
    }
    
    var locationName : String {
        return result.origin.name
    }
    
    var lastKnownLocationName : String {
        return result.location.name
    }
    
    var episode : [String] {
        return result.episode
    }
}
