//
//  AppCoordinator.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 19.06.24.
//

import UIKit
import SwiftUI

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainViewController = MainViewController()
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: false)
    }

    func showCharacterDetail(character: Character) {
        let characterDetailView = CharacterDetailView(character: character, coordinator: self)
        let hostingController = UIHostingController(rootView: characterDetailView)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func showEpisodeDetail(episode: Episode) {
        let episodeDetailView = EpisodeDetailView(episode: episode, coordinator: self)
        let hostingController = UIHostingController(rootView: episodeDetailView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}
