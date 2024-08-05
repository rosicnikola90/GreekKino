//
//  Constants.swift
//  greek_kino
//
//  Created by Nikola Rosic on 3.8.24..
//

import Foundation

enum URLs {
    case livePreviewUrl
    case futureGamesUrl
    case historyOfGames(String, String)
    case drawDetails(String)
    
    var urlString: String {
        switch self {
        case .livePreviewUrl:
            "https://oldsite.mozzartbet.com/sr/lotto-animation/26/#/"
        case .futureGamesUrl:
            "https://api.opap.gr/draws/v3.0/1100/upcoming/20"
        case .historyOfGames(let dateFrom, let dateTo):
            "https://api.opap.gr/draws/v3.0/1100/draw-date/\(dateFrom)/\(dateTo)"
        case .drawDetails(let id):
            "https://api.opap.gr/draws/v3.0/1100/\(id)"
        }
    }
}

enum GameStatus {
    case inFuture
    case live
    case finished
    
    var title: String {
        switch self {
        case .inFuture:
            return "Uskoro"
        case .live:
            return "Uživo"
        case .finished:
            return "Završeno"
        }
    }
}

struct FormatHelper {
    
    static func formatUnixTimeHHmm(_ unixTime: Int, dateFormat: String = "HH:mm") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    static func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    static func checkUnixTimeStatus(_ unixTime: Int) -> GameStatus {
        let currentDate = Date()
        let givenDate = Date(timeIntervalSince1970: TimeInterval(unixTime) / 1000)
        let threeMinutesAgo = currentDate.addingTimeInterval(-180)
        
        if givenDate > currentDate {
            return .inFuture
        } else if givenDate <= currentDate && givenDate >= threeMinutesAgo {
            return .live
        } else {
            return .finished
        }
    }
    
    static func formatUnixTime(_ unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func formatDateToddMMyyyy(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }

    static func formatDateToYYYYMMDD(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

