//
//  HistoryViewModel.swift
//  greek_kino
//
//  Created by Nikola Rosic on 4.8.24..
//

import Foundation

final class HistoryViewModel: ObservableObject {
    
    @Published var historyGames: [HistoryGameModel] = []
    @Published var historyGamesOnChange: [HistoryGameModel] = []
    
    func getHistoryGames() {
        GameManager.shared.fetchHistoryGamesData(forDateFrom: "2024-08-03", andDateTo: "2024-08-03") {[unowned self] result in
            switch result {
            case .success(let games):
                self.historyGamesOnChange = games.content ?? []
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
