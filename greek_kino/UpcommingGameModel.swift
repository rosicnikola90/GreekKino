//
//  FutureGameModel.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import Foundation

struct UpcomingGameModel: Codable, Equatable, Identifiable {
    let gameId: Int
    let drawId: Int
    let drawTime: Int
    let status: String
    let drawBreak: Int
    let visualDraw: Int
    
    var id: Int { drawId }
}
