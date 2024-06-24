//
//  MainViewController.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 19.06.24.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    var coordinator: AppCoordinator?
    private var characters = [Character]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Rick & Morty"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        fetchCharacters()
        
        let notificationButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showRandomLocation))
        navigationItem.rightBarButtonItem = notificationButton
    }
    
    //MARK: - Random Location Action
    @objc private func showRandomLocation() {
        fetchRandomLocation { [weak self] result in
            switch result {
            case .success(let location):
                DispatchQueue.main.async {
                    let locationDetailView = LocationDetailView(location: location)
                    let hostingController = UIHostingController(rootView: locationDetailView)
                    self?.present(hostingController, animated: true, completion: nil)
                }
            case .failure(let error):
                print("Error fetching random location: \(error)")
            }
        }
    }
    
    //MARK: - Fetching Characters
    private func fetchCharacters() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else { return }
        NetworkingService.shared.fetchData(from: url) { result in
            switch result {
            case .success(let dictionary):
                if let results = dictionary["results"] as? [[String: Any]] {
                    self.characters = results.compactMap { Character(from: $0) }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                print("Error fetching characters: \(error)")
            }
        }
    }
    
    //MARK: - Fetching Random Location
    private func fetchRandomLocation(completion: @escaping (Result<Location, Error>) -> Void) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/location") else { return }
        NetworkingService.shared.fetchData(from: url) { result in
            switch result {
            case .success(let dictionary):
                if let results = dictionary["results"] as? [[String: Any]] {
                    let randomIndex = Int.random(in: 0..<results.count)
                    let randomLocationData = results[randomIndex]
                    if let location = Location(from: randomLocationData) {
                        completion(.success(location))
                    } else {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid location data"])
                        completion(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//MARK: TableView Extension
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCollectionViewCell
        let character = characters[indexPath.item]
        cell.configure(with: character)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.item]
        coordinator?.showCharacterDetail(character: character)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 180)
    }
}
