//
//  UpcomingGamesViewModel.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import Foundation

final class UpcomingGamesViewModel: ObservableObject {
    
    @Published var futureGames: [UpcomingGameModel] = []
    @Published var futureGamesOnChange: [UpcomingGameModel] = []
    @Published var selectedGame: UpcomingGameModel? = nil
    @Published var alertMessage: String?


    func getFutureGames() {
        GameManager.shared.fetchUpcomingGamesData {[weak self] result in
            switch result {
            case .success(let games):
                self?.futureGamesOnChange = games
            case .failure(let failure):
                self?.alertMessage = failure.localizedDescription
            }
        }
    }
}
