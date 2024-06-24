//
//  CharacterDetailVM.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 19.06.24.
//

import Foundation

class CharacterDetailVM: ObservableObject {
    @Published var episodes = [Episode]()
    @Published var isLoading = false

    func fetchEpisodes(for character: Character) {
        let dispatchGroup = DispatchGroup()
        isLoading = true
        var uniqueEpisodes = Set<Episode>()
        
        for urlString in character.episodes {
            dispatchGroup.enter()
            guard let url = URL(string: urlString) else {
                dispatchGroup.leave()
                continue
            }
            NetworkingService.shared.fetchData(from: url) { result in
                switch result {
                case .success(let dictionary):
                    if let episode = Episode(from: dictionary) {
                        DispatchQueue.main.async {
                            uniqueEpisodes.insert(episode)
                        }
                    }
                case .failure(let error):
                    print("Error fetching episode: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
            self.episodes = Array(uniqueEpisodes)
        }
    }
    
    func deleteEpisode(at offsets: IndexSet) {
        episodes.remove(atOffsets: offsets)
    }
    
    func moveEpisode(from source: IndexSet, to destination: Int) {
        episodes.move(fromOffsets: source, toOffset: destination)
    }
}
