//
//  GameManager.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import Foundation

protocol GameManagerDelegate {
    func fetchFutureGamesData(completion: @escaping (Result<[FutureGameModel], Error>) -> Void)
}

struct GameManager: GameManagerDelegate {
    
    static let shared = GameManager()
    
    private let networkService = NetworkService.shared
    
    private let futureGamesUrl = "https://api.opap.gr/draws/v3.0/1100/upcoming/20"
    
    private init() {}
    
    func fetchFutureGamesData(completion: @escaping (Result<[FutureGameModel], Error>) -> Void) {
        networkService.get(url: URL(string: futureGamesUrl)!) { (result: Result<[FutureGameModel], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
