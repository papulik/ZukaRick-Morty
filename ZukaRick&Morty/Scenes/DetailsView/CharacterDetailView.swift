//
//  CharacterDetailView.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 19.06.24.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @ObservedObject var viewModel = CharacterDetailVM()
    var coordinator: AppCoordinator?

    init(character: Character, coordinator: AppCoordinator?) {
        self.character = character
        self.coordinator = coordinator
        self.viewModel.fetchEpisodes(for: character)
    }

    var body: some View {
        VStack {
            ZukasAsyncImage(url: character.image)
                .frame(width: 200, height: 200)
                .clipShape(Circle())

            Text(character.name)
                .font(.largeTitle)
                .padding()
            
            Text("Episodes:")

            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                List {
                    ForEach(viewModel.episodes) { episode in
                        Button(action: {
                            coordinator?.showEpisodeDetail(episode: episode)
                        }) {
                            Text(episode.name)
                        }
                        .onDrag {
                            return NSItemProvider(object: String(episode.id) as NSString)
                        }
                    }
                    .onMove(perform: moveEpisode)
                    .onDelete(perform: viewModel.deleteEpisode)
                }
            }
        }
    }

    private func moveEpisode(from source: IndexSet, to destination: Int) {
        viewModel.moveEpisode(from: source, to: destination)
    }
}
