//
//  HistoryGameModel.swift
//  greek_kino
//
//  Created by Nikola Rosic on 4.8.24..
//

import Foundation

struct HistoryContent: Codable {
    let content: [HistoryGameModel]?
}

struct HistoryGameModel: Codable, Identifiable, Equatable {
    
    static func == (lhs: HistoryGameModel, rhs: HistoryGameModel) -> Bool {
        lhs.drawId ?? 0 == rhs.drawId ?? 0
    }
    
    let gameId: Int?
    let drawId: Int?
    let drawTime: Int?
    let status: String?
    let drawBreak: Int?
    let visualDraw: Int?
    let winningNumbers: WinningNumbers?
    
    var id: Int { drawId ?? 0 }
}
    
struct WinningNumbers: Codable {
    let list: [Int]?
}
