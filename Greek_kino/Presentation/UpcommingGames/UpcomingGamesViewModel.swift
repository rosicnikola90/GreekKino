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
    @Published var countdownViewModels: [Int: CountdownViewModel] = [:]

    func getFutureGames() {
        GameManager.shared.fetchUpcomingGamesData {[weak self] result in
            switch result {
            case .success(let games):
                self?.futureGamesOnChange = games
                for game in self?.futureGamesOnChange ?? [] {
                    if self?.countdownViewModels[game.drawId] == nil {
                        self?.countdownViewModels[game.drawId] = CountdownViewModel(drawTime: game.drawTime)
                    }
                }
            case .failure(let failure):
                self?.alertMessage = failure.localizedDescription
            }
        }
    }    
}
