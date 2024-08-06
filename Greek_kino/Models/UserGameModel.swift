//
//  UserGameModel.swift
//  greek_kino
//
//  Created by Nikola Rosic on 3.8.24..
//

import Foundation
import SwiftData

@Model
final class UserGameModel {
    let id: String
    let game: UpcomingGameModel
    let numbers: [Int]
    let quote: Double
    
    init(game: UpcomingGameModel, numbers: [Int], quote: Double) {
        self.id = UUID().uuidString
        self.game = game
        self.numbers = numbers
        self.quote = quote
    }
}
