//
//  HistoryViewModel.swift
//  greek_kino
//
//  Created by Nikola Rosic on 4.8.24..
//

import Foundation

final class HistoryViewModel: ObservableObject {
    @Published var showFromDatePicker = false {
        didSet {
            if !showFromDatePicker {
                getHistoryGames()
            }
        }
    }
    @Published var showToDatePicker = false {
        didSet {
            if !showToDatePicker {
                getHistoryGames()
            }
        }
    }
    @Published var fromDate = Date()
    @Published var toDate = Date()
    @Published var historyGames: [HistoryGameModel] = []
    @Published var historyGamesOnChange: [HistoryGameModel] = []
    @Published var showingSearchAlert = false
    @Published var searchText = ""
    @Published var searchedGameOnChange: HistoryGameModel?
    @Published var searchedGame: HistoryGameModel?
    
    @Published var alertMessage: String?

    func getHistoryGames() {
        historyGamesOnChange = []
        GameManager.shared.fetchHistoryGamesData(forDateFrom: FormatHelper.formatDateToYYYYMMDD(fromDate), andDateTo: FormatHelper.formatDateToYYYYMMDD(toDate)) { [weak self] result in
            switch result {
            case .success(let games):
                self?.historyGamesOnChange = games.content ?? []
            case .failure(let failure):
                self?.alertMessage = failure.localizedDescription
            }
        }
    }

    func search() {
        guard let drawId = Int(searchText) else { return }
        GameManager.shared.getGame(forDraw: drawId) { [weak self] result in
            switch result {
            case .success(let game):
                self?.searchedGameOnChange = game
                self?.searchText = ""
            case .failure(let failure):
                self?.alertMessage = failure.localizedDescription
            }
        }
    }
}
