//
//  Constants.swift
//  assessment-73
//
//  Created by Orhan Erbas on 3.04.2021.
//

import Foundation

struct Constants {
    static var consBaseUrl = "https://rickandmortyapi.com/api/character/"
    static var baseUrl = "https://rickandmortyapi.com/api/character"
    

}

class Globals {
    static let shared = Globals()

    var resultEpisode : [Episode] = []
    var localFavs = [Any]()
}
