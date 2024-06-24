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
        let dispatchGroup = DispatchGroup()
        isLoading = true
        errorMessage = nil
        var uniqueCharacters = Set<Character>()

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
                switch result {
                case .success(let dictionary):
                    if let character = Character(from: dictionary) {
                        DispatchQueue.main.async {
                            uniqueCharacters.insert(character)
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
            self.characters = Array(uniqueCharacters)
            if self.errorMessage == nil && self.characters.isEmpty {
                self.errorMessage = "No characters found"
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
