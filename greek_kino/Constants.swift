//
//  Constants.swift
//  greek_kino
//
//  Created by Nikola Rosic on 3.8.24..
//

import Foundation


struct Constants {
    
    private init() {}
    
    static let shared = Constants()
    
    
}


enum URLs {
    case livePreviewUrl
    case futureGamesUrl
    case historyOfGames(String, String)
    
    var urlString: String {
        switch self {
        case .livePreviewUrl:
            "https://oldsite.mozzartbet.com/sr/lotto-animation/26/#/"
        case .futureGamesUrl:
            "https://api.opap.gr/draws/v3.0/1100/upcoming/20"
        case .historyOfGames(let dateFrom, let dateTo):
            "https://api.opap.gr/draws/v3.0/1100/draw-date/\(dateFrom)/\(dateTo)"
        }
    }
}
