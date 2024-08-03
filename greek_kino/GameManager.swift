//
//  GameManager.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import Foundation

protocol GameManagerDelegate {
    func fetchFutureGamesData(completion: @escaping (Result<[UpcomingGameModel], Error>) -> Void)
}

final class GameManager: GameManagerDelegate, ObservableObject {
    
    static let shared = GameManager()
    @Published var userGames: [UserGameModel] = []
    private let networkService = NetworkService.shared
    private let futureGamesUrl = "https://api.opap.gr/draws/v3.0/1100/upcoming/20"

    private init() {}
    
    func addGame(forUpcomingGame game: UpcomingGameModel, forNumbers numbers: [Int]) {
        let userGame = UserGameModel(game: game, numbers: numbers)
        userGames.append(userGame)
    }
    
    func fetchFutureGamesData(completion: @escaping (Result<[UpcomingGameModel], Error>) -> Void) {
        networkService.get(url: URL(string: futureGamesUrl)!) { (result: Result<[UpcomingGameModel], Error>) in
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
