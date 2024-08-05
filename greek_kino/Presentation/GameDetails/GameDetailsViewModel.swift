//
//  GameDetailsViewModel.swift
//  greek_kino
//
//  Created by Nikola Rosic on 5.8.24..
//

import Foundation

final class GameDetailsViewModel: ObservableObject {
    
    let game: UpcomingGameModel
    @Published var selectedNumbers: [Int] = []
    var countdownViewModel: CountdownViewModel
    @Published var maxReached = false
    @Published var showAlert = false
    let startingQuote = 3.75
    
    init(game: UpcomingGameModel) {
        self.game = game
        self.countdownViewModel = CountdownViewModel(drawTime: game.drawTime)
    }
    
    func numberPressed(number: Int) {
        if let index = selectedNumbers.firstIndex(of: number) {
            selectedNumbers.remove(at: index)
        } else {
            if selectedNumbers.count == 15 {
                maxReached = true
            } else {
                selectedNumbers.append(number)
            }
        }
    }
    
    func generateUniqueRandomNumbers() -> [Int] {
        var numbers: Set<Int> = []
        while numbers.count < 15 {
            let randomNumber = Int.random(in: 1...80)
            numbers.insert(randomNumber)
        }
        return Array(numbers).shuffled()
    }

}
