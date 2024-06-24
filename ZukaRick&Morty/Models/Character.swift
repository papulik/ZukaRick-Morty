//
//  Character.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 19.06.24.
//

import Foundation

struct Character: Equatable, Hashable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let episodes: [String]
    
    init?(from dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
              let name = dictionary["name"] as? String,
              let image = dictionary["image"] as? String,
              let episodes = dictionary["episode"] as? [String] else {
            return nil
        }
        self.id = id
        self.name = name
        self.image = image
        self.episodes = episodes
    }
}
