//
//  EpisodeViewModel.swift
//  assessment-73
//
//  Created by Orhan Erbas on 5.04.2021.
//

import Foundation

struct EpisodeViewModel {
    let result : Episode
    
    var name : String {
        return result.name!
    }
    
    var air_date : String {
        return result.air_date!
    }
}
