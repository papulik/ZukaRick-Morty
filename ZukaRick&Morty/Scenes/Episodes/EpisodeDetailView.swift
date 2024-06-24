//
//  EpisodeDetailView.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 19.06.24.
//

import SwiftUI

struct EpisodeDetailView: View {
    @ObservedObject var viewModel: EpisodeDetailVM
    var coordinator: AppCoordinator?

    init(episode: Episode, coordinator: AppCoordinator?) {
        self.viewModel = EpisodeDetailVM(episode: episode)
        self.coordinator = coordinator
        self.viewModel.fetchCharacters()
    }

    var body: some View {
        VStack {
            Text(viewModel.episode.name)
                .font(.largeTitle)
                .padding()

            Text(viewModel.episode.airDate)
                .padding()

            Text("Characters:")

            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                List {
                    ForEach(viewModel.characters) { character in
                        Text(character.name)
                            .foregroundColor(.blue)
                            .onDrag {
                                return NSItemProvider(object: String(character.id) as NSString)
                            }
                    }
                    .onMove(perform: moveCharacter)
                    .onDelete(perform: viewModel.deleteCharacter)
                }
            }
        }
    }

    private func moveCharacter(from source: IndexSet, to destination: Int) {
        viewModel.moveCharacter(from: source, to: destination)
    }
}
