//
//  EpisodeDetailVM.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 23.06.24.
//

import Foundation

class EpisodeDetailVM: ObservableObject {
    @Published var characters = [Character]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let episode: Episode

    init(episode: Episode) {
        self.episode = episode
    }

    func fetchCharacters() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
            self.characters = []
        }
        
        let dispatchGroup = DispatchGroup()
        
        for urlString in episode.characters {
            dispatchGroup.enter()
            guard let url = URL(string: urlString) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid URL: \(urlString)"
                }
                dispatchGroup.leave()
                continue
            }
            
            NetworkingService.shared.fetchData(from: url) { (result: Result<[String: Any], Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let dictionary):
                        if let character = Character(from: dictionary) {
                            if !self.characters.contains(where: { $0.id == character.id }) {
                                self.characters.append(character)
                            }
                        }
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.isLoading = false
                if self.errorMessage == nil && self.characters.isEmpty {
                    self.errorMessage = "No characters found"
                } else {
                    let ids = self.characters.map { $0.id }
                    let uniqueIds = Set(ids)
                }
            }
        }
    }
    
    func deleteCharacter(at offsets: IndexSet) {
        characters.remove(atOffsets: offsets)
    }
    
    func moveCharacter(from source: IndexSet, to destination: Int) {
        characters.move(fromOffsets: source, toOffset: destination)
    }
}
