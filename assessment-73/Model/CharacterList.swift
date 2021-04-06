//
//  CharacterList.swift
//  assessment-73
//
//  Created by Orhan Erbas on 3.04.2021.
//

import Foundation

struct CharacterList : Decodable {
    var info: Info!
    var results: [Character]!

    enum CodingKeys: String, CodingKey {
        case info = "info"
        case results = "results"
    }
}
