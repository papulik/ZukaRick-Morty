//
//  NetworkingService.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 19.06.24.
//

import Foundation

class NetworkingService {
    static let shared = NetworkingService()
    
    private let cache = NSCache<NSString, CachedItem>()
    private let cacheTimeout: TimeInterval = 600
    
    func fetchData(from url: URL, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let cacheKey = url.absoluteString as NSString
        
        if let cachedItem = cache.object(forKey: cacheKey), !isCacheExpired(cachedItem.timestamp) {
            completion(.success(cachedItem.data))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])
                completion(.failure(error))
                return
            }
            
            do {
                if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    //MARK: Cacheing Data:
                    let cachedItem = CachedItem(data: dictionary, timestamp: Date())
                    self?.cache.setObject(cachedItem, forKey: cacheKey)
                    
                    completion(.success(dictionary))
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    //MARK: After 10 minutes:
    private func isCacheExpired(_ timestamp: Date) -> Bool {
        return Date().timeIntervalSince(timestamp) > cacheTimeout
    }
}

class CachedItem: NSObject {
    let data: [String: Any]
    let timestamp: Date
    
    init(data: [String: Any], timestamp: Date) {
        self.data = data
        self.timestamp = timestamp
    }
}

