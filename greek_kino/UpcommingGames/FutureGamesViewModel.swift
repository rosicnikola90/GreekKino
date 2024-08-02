//
//  FutureGamesViewModel.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import Foundation

final class FutureGamesViewModel: ObservableObject {
    
    @Published var futureGames: [FutureGameModel] = []
    @Published var futureGamesOnChange: [FutureGameModel] = []
    
    private let gameManager = GameManager.shared
    
    func getFutureGames() {
        gameManager.fetchFutureGamesData {[unowned self] result in
            switch result {
            case .success(let games):
                self.futureGamesOnChange = games
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
