//
//  GameManager.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import Foundation

protocol GameManagerDelegate {
    func fetchUpcomingGamesData(completion: @escaping (Result<[UpcomingGameModel], Error>) -> Void)
    func fetchHistoryGamesData(forDateFrom fromDate: String, andDateTo toDate: String, completion: @escaping (Result<HistoryContent, Error>) -> Void)
    func getGame(forDraw drawId: Int, completion: @escaping (Result<HistoryGameModel, Error>) -> Void)
}

final class GameManager: GameManagerDelegate, ObservableObject {
    
    static let shared = GameManager()
    @Published var loading = false
    private let networkService = NetworkService.shared

    private init() {}
    
    func fetchUpcomingGamesData(completion: @escaping (Result<[UpcomingGameModel], Error>) -> Void) {
        loading = true
        networkService.get(url: URL(string: URLs.futureGamesUrl.urlString)!) { [weak self] (result: Result<[UpcomingGameModel], Error>) in
            DispatchQueue.main.async {
                self?.loading = false
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchHistoryGamesData(forDateFrom fromDate: String, andDateTo toDate: String, completion: @escaping (Result<HistoryContent, Error>) -> Void) {
        loading = true
        networkService.get(url: URL(string: URLs.historyOfGames(fromDate, toDate).urlString)!) {[weak self] (result: Result<HistoryContent, Error>) in
            DispatchQueue.main.async {
                self?.loading = false
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getGame(forDraw drawId: Int, completion: @escaping (Result<HistoryGameModel, Error>) -> Void) {
        loading = true
        networkService.get(url: URL(string: URLs.drawDetails(String(drawId)).urlString)!) {[weak self] (result: Result<HistoryGameModel, Error>) in
            DispatchQueue.main.async {
                self?.loading = false
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
