//
//  Episode.swift
//  assessment-73
//
//  Created by Orhan Erbas on 5.04.2021.
//

import Foundation

struct Episode : Decodable {
    let id : Int?
    let name : String?
    let air_date : String?
    let episode : String?
    let characters : [String]?
    let url : String?
    let created : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case air_date = "air_date"
        case episode = "episode"
        case characters = "characters"
        case url = "url"
        case created = "created"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        air_date = try values.decodeIfPresent(String.self, forKey: .air_date)
        episode = try values.decodeIfPresent(String.self, forKey: .episode)
        characters = try values.decodeIfPresent([String].self, forKey: .characters)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        created = try values.decodeIfPresent(String.self, forKey: .created)
    }
}
