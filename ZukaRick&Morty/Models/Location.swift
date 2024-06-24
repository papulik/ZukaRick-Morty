//
//  Location.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 24.06.24.
//

import Foundation

struct Location: Equatable, Hashable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    
    init?(from dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
              let name = dictionary["name"] as? String,
              let type = dictionary["type"] as? String,
              let dimension = dictionary["dimension"] as? String,
              let residents = dictionary["residents"] as? [String] else {
            return nil
        }
        self.id = id
        self.name = name
        self.type = type
        self.dimension = dimension
        self.residents = residents
    }
}
