//
//  Episode.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 24.06.24.
//

import Foundation

struct Episode: Equatable, Hashable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let characters: [String]
    
    init?(from dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
              let name = dictionary["name"] as? String,
              let airDate = dictionary["air_date"] as? String,
              let characters = dictionary["characters"] as? [String] else {
            return nil
        }
        self.id = id
        self.name = name
        self.airDate = airDate
        self.characters = characters
    }
}
